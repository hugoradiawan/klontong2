import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klontong/core/global_keys.dart';
import 'package:klontong/core/http_client/http_client.state.dart';
import 'package:klontong/core/http_client/post.state.dart';
import 'package:klontong/core/toast.dart';
import 'package:klontong/core/ui_api_bloc.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.uiapibloc.dart';
import 'package:klontong/features/catalog_items/catalog/category.dart';
import 'package:klontong/features/catalog_items/create_edit_item/add_category_dialog/add_category_dialog.apibloc.dart';
import 'package:klontong/features/catalog_items/create_edit_item/add_category_dialog/add_category_dialog.state.dart';

class AddCategoryDialogUiApiBloc
    extends UiApiCubit<AddCategoryDialogState, AddCategoryDialogApiBloc> {
  AddCategoryDialogUiApiBloc({
    Category? category,
    AddCategoryDialogApiBloc? api,
    required this.catalogPageUiApiBloc,
  }) : super(
          AddCategoryDialogState(category: category),
          api ?? AddCategoryDialogApiBloc(),
        );

  final ImagePicker picker = ImagePicker();
  StreamSubscription<HttpClientState>? createSub;
  final CatalogPageUiApiBloc catalogPageUiApiBloc;

  Future<void> updateImage() async {
    final XFile? xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    emit(state.copyWith(file: File(xfile.path)));
  }

  void updateName(String data) {
    emit(state.copyWith(
      category: state.category?.copyWith(name: data) ?? Category(name: data),
    ));
  }

  void updateColor(Color data) {
    emit(state.copyWith(
      category: state.category?.copyWith(color: data) ?? Category(color: data),
    ));
  }

  void addCategory() {
    if (state.category?.name == null && state.file == null) return;
    if (state.category?.color == null) {
      updateColor(Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    }
    createSub =
        api.createCategory(state.category!, state.file!).listen((event) {
      if (event is PostLoading) {
        emit(state.copyWith(progress: event.progress));
      } else if (event is PostFailed) {
        emit(state.copyWith(progress: 0));
        Toast.errorPostFailed(event);
      } else if (event is PostComplete) {
        emit(state.copyWith(progress: 0));
        catalogPageUiApiBloc.getCategory();
        coreGlobalKey.currentContext!.pop();
      }
    });
  }

  @override
  Future<void> close() {
    createSub?.cancel();
    return super.close();
  }
}
