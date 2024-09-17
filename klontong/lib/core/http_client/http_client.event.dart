import 'dart:io';

import 'package:klontong/core/typedef.dart';

abstract class HttpClientEvent {}

class PostEvent extends HttpClientEvent {
  final String endPoint, label;
  final JSON? data, headers, queryParameters;
  final List<File>? file;
  PostEvent(
    this.endPoint, {
    this.data,
    this.headers,
    this.file,
    this.queryParameters,
    required this.label,
  });
}

class GetEvent extends HttpClientEvent {
  final String endPoint, label;
  final JSON? data, headers, queryParameters;
  GetEvent(
    this.endPoint, {
    this.data,
    this.headers,
    this.queryParameters,
    required this.label,
  });
}
