import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:klontong/core/api_bloc.dart';
import 'package:klontong/core/http_client/get.state.dart';
import 'package:klontong/core/http_client/http_client.state.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.apibloc.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.state.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.uiapibloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

Future<void> main() async {
  late Storage storage;

  group('CatalogPageUiApiBloc Tests', () {
    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
      storage = MockStorage();
      when(
        () => storage.write(any(), any<dynamic>()),
      ).thenAnswer((_) async => {});
      when(() => storage.read(any())).thenReturn(null);
      HydratedBloc.storage = storage;
      registerFallbackValue(RequestOptions(path: ''));
      registerFallbackValue(
        DioException(requestOptions: RequestOptions(path: '')),
      );
      registerFallbackValue(const CatalogPageState());
    });

    blocTest<CatalogPageUiApiBloc, CatalogPageState>(
      'emits states in order when getItems is successful',
      build: () {
        final mockApiBloc = MockCatalogPageApiBloc();
        when<Stream<HttpClientState>>(() => mockApiBloc.getItems(
              page: any(named: 'page'),
              limit: any(named: 'limit'),
            )).thenAnswer((_) => Stream.fromIterable([
              const GetLoading(onReceiveProgress: 50, label: 'getItems'),
              GetComplete(
                response: MockResponse(
                  data: {
                    'data': [
                      {'id': 1, 'name': 'Item 1'},
                      {'id': 2, 'name': 'Item 2'},
                    ],
                  },
                  statusCode: 200,
                ),
                label: 'getItems',
              ),
            ]));
        when<Stream<HttpClientState>>(() => mockApiBloc.getCategory())
            .thenAnswer((_) => Stream.fromIterable([
                  const GetLoading(onReceiveProgress: 50, label: 'getCategory'),
                  GetComplete(
                    response: MockResponse(
                      data: {
                        'data': [
                          {'id': 1, 'name': 'Item 1'},
                          {'id': 2, 'name': 'Item 2'},
                        ],
                      },
                      statusCode: 200,
                    ),
                    label: 'getCategory',
                  ),
                ]));
        return CatalogPageUiApiBloc(api: mockApiBloc);
      },
      act: (bloc) => bloc.getItems(1),
      expect: () => [
        isA<CatalogPageState>()
            .having((s) => s.getItemsProgress, 'getItemsProgress', 0.0),
        isA<CatalogPageState>()
            .having((s) => s.getItemsProgress, 'getItemsProgress', 0.0)
            .having((s) => s.items.length, 'items.length', 2),
      ],
    );

    blocTest<CatalogPageUiApiBloc, CatalogPageState>(
      'emits error state when getItems fails',
      build: () {
        final mockApiBloc = MockCatalogPageApiBloc();
        when<Stream<HttpClientState>>(() => mockApiBloc.getItems(
                page: any(named: 'page'), limit: any(named: 'limit')))
            .thenAnswer((_) => Stream.fromIterable([
                  GetFailed(
                    response: MockResponse(
                      data: {},
                      statusCode: 500,
                    ),
                    stackTrace: StackTrace.empty,
                    socketException: const SocketException(''),
                    label: 'getItems',
                  ),
                ]));
        when<Stream<HttpClientState>>(() => mockApiBloc.getCategory())
            .thenAnswer((_) => Stream.fromIterable([
                  GetFailed(
                    response: MockResponse(
                      data: {},
                      statusCode: 500,
                    ),
                    stackTrace: StackTrace.empty,
                    socketException: const SocketException(''),
                    label: 'getCategory',
                  ),
                ]));
        return CatalogPageUiApiBloc(api: mockApiBloc, byPassToast: true);
      },
      act: (bloc) => bloc.getItems(1),
      expect: () => [],
      errors: () => [],
    );
  });
}

class MockCatalogPageApiBloc extends Mock implements CatalogPageApiBloc {}

class MockApiBloc extends Mock implements ApiBloc {}

class MockResponse<T> extends Mock implements Response<T> {
  @override
  final T? data;

  @override
  final int statusCode;

  MockResponse({required this.data, required this.statusCode});
}
