import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:klontong/features/login/DTOs/login.dto.dart';
import 'package:klontong/features/login/UIs/login_error_type.enum.dart';

class LoginPageState extends Equatable {
  final LoginDto data;
  final String reTypePassword;
  final Set<LoginErrorType> errorList;
  final PageController? pageController;
  final double progress;
  const LoginPageState({
    this.data = const LoginDto(),
    this.reTypePassword = '',
    this.errorList = const {},
    this.pageController,
    this.progress = 0,
  });
  @override
  List<Object?> get props => [data, reTypePassword, errorList, progress];

  LoginPageState copyWith({
    String? email,
    String? password,
    String? reTypePassword,
    Set<LoginErrorType>? errorList,
    double? progress,
  }) =>
      LoginPageState(
        data: LoginDto(
          email: email ?? data.email,
          password: password ?? data.password,
        ),
        reTypePassword: reTypePassword ?? this.reTypePassword,
        errorList: errorList ?? this.errorList,
        pageController: pageController,
        progress: progress ?? this.progress,
      );
}
