import 'dart:async';
import 'dart:io';

import 'package:klontong/core/api_bloc.dart';
import 'package:klontong/core/http_client/http_client.state.dart';
import 'package:klontong/features/catalog_items/catalog/category.dart';

class AddCategoryDialogApiBloc extends ApiBloc {
  Stream<HttpClientState> createCategory(Category category, File file) => post(
        endpoint: 'category',
        label: 'createCategory',
        data: category.toJson(withImage: false, withId: false),
        files: [file],
      );
}