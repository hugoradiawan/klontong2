import 'package:klontong/core/http_client/http_client.state.dart';

class PostLoading extends LoadingState {
  const PostLoading(
      {super.onSendProgress,
      super.onReceiveProgress,
      super.onSendTotal,
      super.onReceiveTotal,
      required super.label});
}

class PostComplete extends Complete {
  const PostComplete({required super.response, required super.label});
}

class PostFailed extends Failed {
  const PostFailed(
      {super.response,
      super.stackTrace,
      super.socketException,
      super.dioException,
      required super.label});
}
