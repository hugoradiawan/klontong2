import 'package:equatable/equatable.dart';
import 'package:klontong/core/typedef.dart';

class AccessTokens extends Equatable {
  final String? accessToken, refreshToken;
  const AccessTokens({this.accessToken, this.refreshToken});

  factory AccessTokens.fromJson(JSON json) => AccessTokens(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );

  JSON get toJson => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };

  @override
  List<Object?> get props => [];
}
