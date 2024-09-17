import 'package:equatable/equatable.dart';
import 'package:klontong/core/access_tokens.dart';
import 'package:klontong/core/typedef.dart';

class UserState extends Equatable {
  final AccessTokens? accessTokens;
  final bool loggedInStatus;
  const UserState({this.accessTokens, this.loggedInStatus = false});

  @override
  List<Object?> get props => [accessTokens, isLoggedIn];

  factory UserState.fromJson(JSON json) =>
      UserState(
        // accessTokens: AccessTokens.fromJson(json['accessTokens'] as Map<String, Object?>),
        loggedInStatus: (json['loggedInStatus'] as bool?) ?? false
        );

  JSON get toJson => {
        // if (accessTokens != null) 'accessTokens': accessTokens!.toJson,
        'loggedInStatus': loggedInStatus,
      };

  UserState copyWith({AccessTokens? accessTokens, bool? loggedInStatus}) =>
      UserState(
        accessTokens: accessTokens ?? this.accessTokens,
        loggedInStatus: loggedInStatus ?? this.loggedInStatus,
        );

  bool get isLoggedIn =>
      accessTokens?.accessToken != null && accessTokens?.refreshToken != null || loggedInStatus;

  UserState reset() => const UserState(accessTokens: null, loggedInStatus: false);
}
