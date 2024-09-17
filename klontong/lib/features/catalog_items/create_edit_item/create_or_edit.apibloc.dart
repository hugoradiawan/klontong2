import 'dart:io';

import 'package:klontong/core/api_bloc.dart';
import 'package:klontong/core/http_client/http_client.state.dart';
import 'package:klontong/features/catalog_items/catalog/item.dart';

class CreateOrEditItemApiBloc extends ApiBloc {
  Stream<HttpClientState> createItem(Item item, File file) => post(
        endpoint: 'item',
        label: 'createItem',
        data: item.toJson(withImage: false, withId: false),
        files: [file],
      );
  Stream<HttpClientState> getItem(String value) => get(
        endpoint: 'item',
        label: 'getItem',
        queryParameters: {'id': value},
      );
}
