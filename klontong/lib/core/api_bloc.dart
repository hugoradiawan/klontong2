import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/global_keys.dart';
import 'package:klontong/core/http_client/http_client.bloc.dart';
import 'package:klontong/core/http_client/http_client.event.dart';
import 'package:klontong/core/http_client/http_client.state.dart';
import 'package:klontong/core/typedef.dart';
import 'package:klontong/core/user_manager/user.cubit.dart';

class ApiBloc {
  const ApiBloc();

  Stream<HttpClientState> post({
    required String endpoint,
    required String label,
    JSON data = const {},
    List<File> files = const [],
    JSON additionalHeaders = const {},
    bool isAuthenticated = true,
  }) {
    final String? ac = coreGlobalKey.currentContext!
        .read<UserCubit>()
        .state
        .accessTokens
        ?.accessToken;
    _client.add(PostEvent(
      endpoint,
      data: data,
      label: label,
      headers: {
        if (isAuthenticated && ac != null) HttpHeaders.authorizationHeader: ac,
        ...additionalHeaders
      },
      file: files,
    ));
    return _client.stream;
  }

  Stream<HttpClientState> get({
    required String endpoint,
    required String label,
    JSON? data,
    JSON additionalHeaders = const {},
    JSON queryParameters = const {},
    bool isAuthenticated = true,
  }) {
    final String? ac = coreGlobalKey.currentContext!
        .read<UserCubit>()
        .state
        .accessTokens
        ?.accessToken;
    _client.add(GetEvent(
      endpoint,
      data: data,
      label: label,
      queryParameters: queryParameters,
      headers: {
        if (isAuthenticated && ac != null) HttpHeaders.authorizationHeader: ac,
        ...additionalHeaders
      },
    ));
    return _client.stream;
  }

  HttpClientBloc get _client =>
      BlocProvider.of<HttpClientBloc>(coreGlobalKey.currentContext!);
}
