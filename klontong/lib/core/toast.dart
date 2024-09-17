import 'package:flutter/material.dart';
import 'package:klontong/core/global_keys.dart';
import 'package:klontong/core/http_client/get.state.dart';
import 'package:klontong/core/http_client/post.state.dart';
import 'package:toastification/toastification.dart';

class Toast {
  static void errorPostFailed(PostFailed event) {
    late final String? msg;
    if (event.dioException != null) {
      msg = (event.dioException?.type.toString() ?? '') +
          (event.dioException?.response?.statusCode?.toString() ?? '');
    } else if (event.socketException != null) {
      msg = event.socketException?.message;
    } else {
      msg = null;
    }
    Toast.error(msg: msg);
  }

    static void errorGetFailed(GetFailed event) {
    late final String? msg;
    if (event.dioException != null) {
      msg = (event.dioException?.type.toString() ?? '') +
          (event.dioException?.response?.statusCode?.toString() ?? '');
    } else if (event.socketException != null) {
      msg = event.socketException?.message;
    } else {
      msg = null;
    }
    Toast.error(msg: msg);
  }

  static void registerSuccessful() {
    Toast.success(msg: 'You are Registered');
  }

  static void success({String? msg, String? title}) {
    final BuildContext context = coreGlobalKey.currentContext!;
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(
        title ?? 'Yay!',
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      description: RichText(
        text: TextSpan(
          text: msg ?? 'The Event is successful',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 100),
      icon: Icon(Icons.check, color: Theme.of(context).colorScheme.onPrimary),
      showIcon: true,
      primaryColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  static void error({String? msg, String? title}) {
    final BuildContext context = coreGlobalKey.currentContext!;
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(
        title ?? 'Ops!',
        style: TextStyle(color: Theme.of(context).colorScheme.onError),
      ),
      description: RichText(
        text: TextSpan(
          text: msg ?? 'Something went wrong',
          style: TextStyle(color: Theme.of(context).colorScheme.onError),
        ),
      ),
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 100),
      icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onError),
      showIcon: true,
      primaryColor: Theme.of(context).colorScheme.error,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }
}
