import 'dart:async';
import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klontong/core/exceptions/empty_response_body.exception.dart';
import 'package:klontong/core/global_keys.dart';
import 'package:klontong/core/http_client/get.state.dart';
import 'package:klontong/core/http_client/http_client.state.dart';
import 'package:klontong/core/http_client/post.state.dart';
import 'package:klontong/core/toast.dart';
import 'package:klontong/core/ui_api_bloc.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.uiapibloc.dart';
import 'package:klontong/features/catalog_items/catalog/category.dart';
import 'package:klontong/features/catalog_items/catalog/item.dart';
import 'package:klontong/features/catalog_items/create_edit_item/create_or_edit.apibloc.dart';
import 'package:klontong/features/catalog_items/create_edit_item/create_or_edit_item.state.dart';

class CreateOrEditItemUiApiCubit
    extends UiApiCubit<CreateOrEditItemState, CreateOrEditItemApiBloc> {
  CreateOrEditItemUiApiCubit({
    required this.itemId,
    required this.catalogPageUiApiBloc,
    CreateOrEditItemApiBloc? api,
  }) : super(
          const CreateOrEditItemState(),
          api ?? CreateOrEditItemApiBloc(),
        ) {
    if (itemId != null) {
      onGetItem();
    } else {
      emit(state.copyWith(item: const Item()));
    }
  }
  StreamSubscription<HttpClientState>? createSub, getSub;
  final CatalogPageUiApiBloc catalogPageUiApiBloc;
  final String? itemId;
  final ImagePicker picker = ImagePicker();

  Future<void> updateImage() async {
    final XFile? xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    emit(state.copyWith(file: File(xfile.path)));
  }

  void updateName(String data) {
    emit(state.copyWith(item: state.item?.copyWith(name: data)));
  }

  void updateSku(String data) {
    emit(state.copyWith(item: state.item?.copyWith(sku: data)));
  }

  void updateDescription(String data) {
    emit(state.copyWith(item: state.item?.copyWith(description: data)));
  }

  void updateCategory(Category data) {
    emit(state.copyWith(
        item: state.item?.copyWith(
      categoryId: data.id,
      categoryName: data.name,
    )));
  }

  void updatePrice(String data) {
    final double? result = double.tryParse(data);
    emit(state.copyWith(
        item: state.item?.copyWith(
      harga: result ?? state.item?.harga,
    )));
  }

  void updateWeight(String data) {
    final double? result = double.tryParse(data);
    emit(state.copyWith(
        item: state.item?.copyWith(
      weight: result ?? state.item?.weight,
    )));
  }

  void updateWidth(String data) {
    final double? result = double.tryParse(data);
    emit(state.copyWith(
        item: state.item?.copyWith(
      width: result ?? state.item?.width,
    )));
  }

  void updateHeight(String data) {
    final double? result = double.tryParse(data);
    emit(state.copyWith(
        item: state.item?.copyWith(
      height: result ?? state.item?.height,
    )));
  }

  void updateLength(String data) {
    final double? result = double.tryParse(data);
    emit(state.copyWith(
        item: state.item?.copyWith(
      length: result ?? state.item?.length,
    )));
  }

  void onCreateItem() {
    if (!(state.item?.isValidToMake ?? false) && state.file == null) return;
    createSub?.cancel();
    createSub = api.createItem(state.item!, state.file!).listen((event) {
      if (event is PostLoading) {
        emit(state.copyWith(progress: event.progress));
      } else if (event is PostFailed) {
        emit(state.copyWith(progress: 0));
        Toast.errorPostFailed(event);
      } else if (event is PostComplete) {
        emit(state.copyWith(progress: 0));
        catalogPageUiApiBloc.getItems();
        gctx.pop();
      }
    });
  }

  void onGetItem() {
    if (itemId == null) return;
    getSub?.cancel();
    getSub = api.getItem(itemId!).listen((event) {
      if (event is GetLoading) {
        emit(state.copyWith(progress: event.progress));
      } else if (event is GetFailed) {
        emit(state.copyWith(progress: 0));
        Toast.errorGetFailed(event);
      } else if (event is GetComplete) {
        if (event.response.data == null) throw EmptyResponseBodyException();
        emit(state.copyWith(
          progress: 1,
          item: Item.fromJson(event.response.data!),
        ));
      }
    });
  }

  @override
  Future<void> close() {
    createSub?.cancel();
    return super.close();
  }
}
