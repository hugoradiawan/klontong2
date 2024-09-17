import 'package:equatable/equatable.dart';
import 'package:klontong/features/login/DTOs/register.dto.dart';
import 'package:klontong/core/typedef.dart';

class LoginDto extends Equatable {
  final String? email, password;
  const LoginDto({this.email, this.password});

  factory LoginDto.fromJson(JSON json) => LoginDto(
        email: json['email'] as String?,
        password: json['password'] as String?,
      );

  JSON get toJson => {
        'email': email,
        'password': password,
      };

  @override
  List<Object?> get props => [email, password];

  bool get isInValid => (email?.isEmpty ?? true) || (password?.isEmpty ?? true);

  RegisterDto get toRegister => RegisterDto(email: email, password: password);
}