import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:klontong/core/http_client/get.state.dart';
import 'package:klontong/core/http_client/http_client.event.dart';
import 'package:klontong/core/http_client/http_client.state.dart';
import 'package:klontong/core/http_client/post.state.dart';
import 'package:klontong/core/typedef.dart';
import 'package:mime/mime.dart';

class HttpClientBloc extends Bloc<HttpClientEvent, HttpClientState> {
  final Dio _client = Dio(BaseOptions(baseUrl: 'http://192.168.88.183:3000/'));

  HttpClientBloc() : super(const InitialHttpClientState(label: '')) {
    _client.transformer = IsolatedBackgroundTransformer();
    // _client.interceptors.add();
    on<PostEvent>(
      (event, emit) async {
        try {
          final List<MultipartFile> files =
              await _convertListFile(event.file ?? []);
          final response = await _client.post<JSON>(
            event.endPoint,
            data: files.isEmpty
                ? event.data
                : FormData.fromMap({
                    ...?event.data,
                    'image': files.length == 1 ? files.first : files,
                  }),
            onSendProgress: (count, total) {
              emit(PostLoading(
                onSendProgress: count,
                onSendTotal: total,
                label: event.label,
              ));
            },
            onReceiveProgress: (count, total) => emit(PostLoading(
              onReceiveProgress: count,
              onReceiveTotal: total,
              label: event.label,
            )),
          );
          emit(PostComplete(response: response, label: event.label));
        } on SocketException catch (e, s) {
          emit(PostFailed(
              stackTrace: s, socketException: e, label: event.label));
        } on DioException catch (e, s) {
          emit(PostFailed(stackTrace: s, dioException: e, label: event.label));
        } catch (e, s) {
          emit(PostFailed(stackTrace: s, label: event.label));
        }
      },
      transformer: concurrent(),
    );

    on<GetEvent>(
      (event, emit) async {
        try {
          final response = await _client.get<JSON>(
            event.endPoint,
            data: event.data,
            queryParameters: event.queryParameters,
            onReceiveProgress: (count, total) => emit(
              GetLoading(
                  onReceiveProgress: count,
                  onReceiveTotal: total,
                  label: event.label),
            ),
          );
          emit(GetComplete(response: response, label: event.label));
        } on SocketException catch (e, s) {
          emit(
              GetFailed(stackTrace: s, socketException: e, label: event.label));
        } on DioException catch (e, s) {
          emit(GetFailed(stackTrace: s, dioException: e, label: event.label));
        } catch (e, s) {
          emit(GetFailed(stackTrace: s, label: event.label));
        }
      },
      transformer: concurrent(),
    );
  }

  static BlocProvider<HttpClientBloc> get provide =>
      BlocProvider<HttpClientBloc>(create: (_) => HttpClientBloc());

  String get baseUrl => _client.options.baseUrl;

  String getCategoryIconUrl(String categoryId) =>
      '${baseUrl}category/icons/$categoryId';

  String getItemImageUrl(String itemId) => '${baseUrl}item/images/$itemId';

  Future<List<MultipartFile>> _convertListFile(List<File> images) async {
    final List<Future<MultipartFile>> listFile =
        List<Future<MultipartFile>>.empty(growable: true);
    for (int i = 0; i < images.length; i++) {
      final String? lookupMime = lookupMimeType(images[i].path);
      listFile.add(
        MultipartFile.fromFile(
          images[i].path,
          filename: images[i].path.split('/').last,
          contentType: (lookupMime?.isNotEmpty ?? false)
              ? MediaType.parse(lookupMime!)
              : null,
        ),
      );
    }
    try {
      return Future.wait<MultipartFile>(listFile);
    } catch (e) {
      debugPrint('converting to MultipartFile Failed');
      return [];
    }
  }
}

class IsolatedBackgroundTransformer extends SyncTransformer {
  IsolatedBackgroundTransformer() : super(jsonDecodeCallback: _decodeJson);
}

FutureOr<dynamic> _decodeJson(String text) {
  return compute(jsonDecode, text);
}
