import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:klontong/core/typedef.dart';

abstract class HttpClientState extends Equatable {
  final String label;
  const HttpClientState({required this.label});
}

class InitialHttpClientState extends HttpClientState {
  const InitialHttpClientState({required super.label});
  @override
  List<Object?> get props => [];
}

class LoadingState extends HttpClientState {
  final int? onSendProgress, onReceiveProgress, onSendTotal, onReceiveTotal;
  const LoadingState({
    this.onSendProgress,
    this.onReceiveProgress,
    this.onSendTotal,
    this.onReceiveTotal,
    required super.label,
  });

  LoadingState copyWith({
    int? onSendProgress,
    int? onReceiveProgress,
    int? onSendTotal,
    int? onReceiveTotal,
    String? label,
  }) =>
      LoadingState(
        onSendProgress: onSendProgress ?? this.onSendProgress,
        onReceiveProgress: onReceiveProgress ?? this.onReceiveProgress,
        onSendTotal: onSendTotal ?? this.onSendTotal,
        onReceiveTotal: onReceiveTotal ?? this.onReceiveTotal,
        label: label ?? this.label,
      );

  @override
  List<Object?> get props => [
        onSendProgress,
        onReceiveProgress,
        onSendTotal,
        onReceiveTotal,
        label,
      ];

  double get progress =>
      ((onSendProgress ?? 0) + (onReceiveProgress ?? 0)) /
      ((onSendTotal ?? 1) + (onReceiveTotal ?? 1));

  double get receiveProgress => (onSendProgress ?? 0) / (onReceiveTotal ?? 1);
}

class Complete extends HttpClientState {
  final Response<JSON> response;
  const Complete({required this.response, required super.label});

  Complete copyWith({Response<JSON>? response, String? label}) => Complete(
        response: response ?? this.response,
        label: label ?? this.label,
      );

  @override
  List<Object?> get props => [response, label];
}

class Failed extends HttpClientState {
  final Response? response;
  final SocketException? socketException;
  final DioException? dioException;
  final StackTrace? stackTrace;
  const Failed({
    this.response,
    this.stackTrace,
    this.socketException,
    this.dioException,
    required super.label,
  });

  Failed copyWith({
    Response<JSON>? response,
    StackTrace? stackTrace,
    String? label,
  }) =>
      Failed(
        response: response ?? this.response,
        stackTrace: stackTrace ?? this.stackTrace,
        label: label ?? this.label,
      );

  @override
  List<Object?> get props => [
        response,
        stackTrace,
        socketException,
        dioException,
        label,
      ];
}
