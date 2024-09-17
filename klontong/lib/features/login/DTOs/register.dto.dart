import 'package:equatable/equatable.dart';
import 'package:klontong/core/typedef.dart';

class RegisterDto extends Equatable {
  final String? email, password;
  const RegisterDto({this.email, this.password});

  factory RegisterDto.fromJson(JSON json) => RegisterDto(
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
}
