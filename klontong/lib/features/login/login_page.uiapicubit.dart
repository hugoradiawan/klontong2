import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:klontong/core/access_tokens.dart';
import 'package:klontong/core/exceptions/empty_response_body.exception.dart';
import 'package:klontong/core/http_client/http_client.state.dart';
import 'package:klontong/core/http_client/post.state.dart';
import 'package:klontong/core/toast.dart';
import 'package:klontong/core/ui_api_bloc.dart';
import 'package:klontong/core/user_manager/user.cubit.dart';
import 'package:klontong/features/login/UIs/login_error_type.enum.dart';
import 'package:klontong/features/login/login_page.apibloc.dart';
import 'package:klontong/features/login/login_page.state.dart';

class LoginPageUiCubit extends UiApiCubit<LoginPageState, LoginPageApiCubit> {
  LoginPageUiCubit({LoginPageApiCubit? api, required this.userCubit})
      : super(
          LoginPageState(pageController: PageController()),
          api ?? LoginPageApiCubit(),
        );
  StreamSubscription<HttpClientState>? loginSub, registerSub;

  final UserCubit userCubit;

  void updateEmail(String data) {
    if (_checkError({
      if (!EmailValidator.validate(data)) LoginErrorType.emailNotValid,
      if (data.isEmpty) LoginErrorType.emptyEmail,
    })) return;
    emit(state.copyWith(email: data, errorList: Set.from({})));
  }

  void updatePassword(String data) {
    if (_checkError({
      if (data.isEmpty) LoginErrorType.emptyPassword,
      if (data.length < 4) LoginErrorType.passwordIsTooShort,
    })) return;
    emit(state.copyWith(password: data, errorList: Set.from({})));
  }

  bool _checkError(Set<LoginErrorType> types) {
    emit(state.copyWith(errorList: types));
    return types.isNotEmpty;
  }

  void updateReTypePassword(String data) {
    if (_checkError({
      if (data != state.data.password) LoginErrorType.passwordNotMatch,
    })) return;
    emit(state.copyWith(reTypePassword: data));
  }

  Future<void> onLogin() async {
    if (state.errorList.isNotEmpty || state.data.isInValid) return;
    loginSub = api.login(state.data).listen((e) => _handleResponse(e));
  }

  void _handleResponse(HttpClientState event, [bool isForRegister = false]) {
    if (event is PostLoading) {
      emit(state.copyWith(progress: event.progress));
    } else if (event is PostFailed) {
      emit(state.copyWith(progress: 0));
      Toast.errorPostFailed(event);
    } else if (event is PostComplete) {
      emit(state.copyWith(progress: 1));
      if (isForRegister) {
        Toast.registerSuccessful();
        to(0);
      } else {
        if (event.response.data == null) throw EmptyResponseBodyException();
        userCubit
            .updateAccestokens(AccessTokens.fromJson(event.response.data!));
      }
    }
  }

  Future<void> onRegister() async {
    if (state.errorList.isNotEmpty || state.data.isInValid) return;
    registerSub = api
        .register(state.data.toRegister)
        .listen((e) => _handleResponse(e, true));
  }

  @override
  Future<void> close() {
    state.pageController?.dispose();
    loginSub?.cancel();
    registerSub?.cancel();
    return super.close();
  }

  void to(int i) {
    state.pageController?.animateToPage(
      i,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
    );
  }
}
