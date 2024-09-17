import 'package:klontong/core/http_client/http_client.state.dart';

class GetLoading extends LoadingState {
  const GetLoading(
      {super.onSendProgress,
      super.onReceiveProgress,
      super.onSendTotal,
      super.onReceiveTotal,
      required super.label});
}

class GetComplete extends Complete {
  const GetComplete({required super.response, required super.label});
}

class GetFailed extends Failed {
  const GetFailed({
    super.response,
    super.stackTrace,
    super.socketException,
    super.dioException,
    required super.label,
  });
}
