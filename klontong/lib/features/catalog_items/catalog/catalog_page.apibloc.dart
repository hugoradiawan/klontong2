import 'package:klontong/core/api_bloc.dart';
import 'package:klontong/core/http_client/http_client.state.dart';

class CatalogPageApiBloc extends ApiBloc {
  Stream<HttpClientState> getCategory() => get(
        endpoint: 'category',
        label: 'getCategory',
        data: {
          'page': 1,
          'limit': 100,
        },
      ).where((event) => event.label == 'getCategory');
  Stream<HttpClientState> getItems({int? page = 1, int? limit = 3}) => get(
        endpoint: 'item',
        label: 'getItems',
        data: {
          'page': page,
          'limit': limit,
        },
      ).where((event) => event.label == 'getItems');
}
