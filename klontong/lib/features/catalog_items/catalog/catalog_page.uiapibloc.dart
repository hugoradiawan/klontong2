import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:klontong/core/exceptions/empty_response_body.exception.dart';
import 'package:klontong/core/http_client/get.state.dart';
import 'package:klontong/core/http_client/http_client.state.dart';
import 'package:klontong/core/toast.dart';
import 'package:klontong/core/typedef.dart';
import 'package:klontong/core/ui_api_bloc.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.apibloc.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.state.dart';
import 'package:klontong/features/catalog_items/catalog/category.dart';
import 'package:klontong/features/catalog_items/catalog/item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CatalogPageUiApiBloc
    extends UiApiCubit<CatalogPageState, CatalogPageApiBloc> {
  CatalogPageUiApiBloc(
      {CatalogPageState? state,
      CatalogPageApiBloc? api,
      this.byPassToast = false})
      : super(
          state ?? const CatalogPageState(),
          api ?? CatalogPageApiBloc(),
        ) {
    getCategory();
    getItems(1);
    _initRefresher();
  }
  StreamSubscription<HttpClientState>? getItemsSub, getCategoriesSub;
  final bool byPassToast;

  void _initRefresher() {
    emit(state.copyWith(refreshController: RefreshController()));
  }

  void onRefresh() {
    getItems(1);
    getCategory();
    emit(state.copyWith(page: 1));
  }

  void onLoading() {
    getItems(state.page + 1);
    getCategory();
  }

  void getItems([int? page]) {
    emit(state.copyWith(page: page));
    getItemsSub?.cancel();
    getItemsSub = api.getItems(page: page, limit: state.limit).listen((event) {
      if (event is GetLoading) {
        emit(state.copyWith(getItemsProgress: event.receiveProgress));
      } else if (event is GetFailed) {
        emit(state.copyWith(getItemsProgress: 0));
        if (!byPassToast) {
          Toast.errorGetFailed(event);
        }
        state.refreshController?.loadComplete();
        state.refreshController?.refreshCompleted();
      } else if (event is GetComplete) {
        final data = event.response.data;
        if (data == null) throw EmptyResponseBodyException();
        final List<Item> result =
            (data['data'] as List).map((e) => Item.fromJson(e)).toList();
        if (result.isEmpty) emit(state.copyWith(page: state.page - 1));
        emit(state.copyWith(getItemsProgress: 0, items: [
          if (state.page != 1) ...state.items,
          ...result,
        ]));
        state.refreshController?.loadComplete();
        state.refreshController?.refreshCompleted();
      } else {
        emit(state.copyWith(getItemsProgress: 0));
      }
    });
  }

  void getCategory() {
    getCategoriesSub?.cancel();
    getCategoriesSub = api.getCategory().listen((event) {
      if (event is GetLoading) {
        emit(state.copyWith(getCategoriesProgress: event.receiveProgress));
      } else if (event is GetFailed) {
        emit(state.copyWith(getCategoriesProgress: 0));
        if (!byPassToast) {
          Toast.errorGetFailed(event);
        }
      } else if (event is GetComplete) {
        if (event.response.statusCode == 200) {
          final data = event.response.data;
          if (data == null) throw EmptyResponseBodyException();
          final List<Category> result =
              (data['data'] as List).map((e) => Category.fromJson(e)).toList();
          emit(state.copyWith(getCategoriesProgress: 1, categories: result));
        } else {
          emit(state.copyWith(getCategoriesProgress: 0));
        }
      }
    });
  }

  @override
  CatalogPageState? fromJson(JSON json) => CatalogPageState.fromJson(json);

  @override
  JSON? toJson(CatalogPageState state) => state.toJson;

  @override
  Future<void> close() {
    getItemsSub?.cancel();
    getCategoriesSub?.cancel();
    return super.close();
  }
}
