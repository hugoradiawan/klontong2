import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:klontong/core/access_tokens.dart';
import 'package:klontong/core/global_keys.dart';
import 'package:klontong/core/storages/secure_storage/secure_storage.state.dart';

class SecureStorageBloc extends Cubit<SecureStorageState> {
  static const String acKey = 'accessTokens';
  SecureStorageBloc()
      : super(
          const SecureStorageState(
            FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            ),
          ),
        );

  Future<void> init() async {
    emit(state.copyWith(accessTokens: await _getAccessTokens()));
  }

  static BlocProvider<SecureStorageBloc> get provide =>
      BlocProvider<SecureStorageBloc>(
        create: (_) => SecureStorageBloc()..init(),
      );

  Future<AccessTokens?> _getAccessTokens() async {
    final String? stored = await state.storage.read(key: acKey);
    if (stored == null) return null;
    final json = await compute(jsonDecode, stored);
    return AccessTokens.fromJson(json as dynamic);
  }

  Future<bool> setAccessToken(AccessTokens? accessTokens) async {
    emit(state.copyWith(accessTokens: accessTokens));
    await state.storage.write(
        key: acKey,
        value: accessTokens == null ? null : jsonEncode(accessTokens.toJson));
    return true;
  }

  static Future<void> clear() => coreGlobalKey.currentContext!
      .read<SecureStorageBloc>()
      .state
      .storage
      .deleteAll();
}
