import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:klontong/core/access_tokens.dart';

class SecureStorageState extends Equatable {
  final FlutterSecureStorage storage;
  final AccessTokens? accessTokens;
  const SecureStorageState(this.storage, {this.accessTokens});
  @override
  List<Object?> get props => [storage, accessTokens];

  SecureStorageState copyWith({AccessTokens? accessTokens}) =>
      SecureStorageState(
        storage,
        accessTokens: accessTokens ?? this.accessTokens,
      );
}
