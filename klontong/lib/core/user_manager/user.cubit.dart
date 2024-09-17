import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:klontong/core/access_tokens.dart';
import 'package:klontong/core/storages/hydrated_storage.dart';
import 'package:klontong/core/storages/secure_storage/secure_storage.cubit.dart';
import 'package:klontong/core/typedef.dart';
import 'package:klontong/core/user_manager/user.state.dart';

class UserCubit extends HydratedCubit<UserState> {
  UserCubit({required this.secureStorageBloc}) : super(const UserState());

  final SecureStorageBloc secureStorageBloc;

  void updateAccestokens(AccessTokens? accessTokens) {
    emit(UserState(
      accessTokens: accessTokens,
      loggedInStatus: accessTokens != null,
    ));
  }

  Future<void> logout() async {
    emit(state.reset());
    await Future.wait([
      KlontongStorage.clear(),
      SecureStorageBloc.clear(),
    ]);
  }

  static BlocProvider<UserCubit> get provide => BlocProvider<UserCubit>(
        create: (cxt) => UserCubit(
          secureStorageBloc: cxt.read<SecureStorageBloc>(),
        ),
      );

  @override
  UserState? fromJson(JSON json) => UserState.fromJson(json);

  @override
  JSON? toJson(UserState state) => state.toJson;
}
