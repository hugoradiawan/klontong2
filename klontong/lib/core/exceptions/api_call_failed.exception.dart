import 'package:dio/dio.dart';

class ApiCallFailedException implements Exception {
  final String message;
  final Response response;

  ApiCallFailedException(this.response,
      [this.message = 'The Api was failed to called.']);

  @override
  String toString() =>
      'ApiCallFailedException: $message endpoint: ${response.requestOptions.uri}, data request: ${response.requestOptions.data}, status code: ${response.statusCode} (${response.statusMessage})';
}