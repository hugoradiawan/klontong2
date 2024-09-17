import 'package:klontong/core/api_bloc.dart';
import 'package:klontong/core/http_client/http_client.state.dart';
import 'package:klontong/features/login/DTOs/login.dto.dart';
import 'package:klontong/features/login/DTOs/register.dto.dart';

class LoginPageApiCubit extends ApiBloc {
  Stream<HttpClientState> login(LoginDto data) => post(
        endpoint: 'auth/login',
        label: 'login',
        data: data.toJson,
        isAuthenticated: false,
      );

  Stream<HttpClientState> register(RegisterDto data) => post(
        endpoint: 'auth/register',
        label: 'register',
        data: data.toJson,
        isAuthenticated: false,
      );
}
