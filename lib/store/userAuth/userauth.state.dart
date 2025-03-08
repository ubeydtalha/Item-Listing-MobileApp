import 'package:supabase_flutter/supabase_flutter.dart';

class UserAuthState {
  final bool isLoading;
  final String error;
  final User? user;
  final Session? session;

  UserAuthState(this.isLoading, this.error, this.user, this.session);

  factory UserAuthState.initial() => UserAuthState(false, '', null, null);

  UserAuthState copyWith(
          {bool? isLoading, String? error, User? user, Session? session}) =>
      UserAuthState(isLoading ?? this.isLoading, error ?? this.error,
          user ?? this.user, session ?? this.session);

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is UserAuthState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          error == other.error &&
          user == other.user;

  @override
  int get hashCode =>
      super.hashCode ^
      runtimeType.hashCode ^
      isLoading.hashCode ^
      error.hashCode ^
      user.hashCode;

  @override
  String toString() =>
      "UserAuthState { isLoading: $isLoading,  error: $error, user: $user }";

  static UserAuthState fromJson(dynamic json) {
    return UserAuthState(
      json['isLoading'] as bool,
      json['error'] as String,
      json['user'] != null ? User.fromJson(json['user']) : null,
      json['session'] != null ? Session.fromJson(json['session']) : null,
    );
  }

  dynamic toJson() {
    return {
      'isLoading': isLoading,
      'error': error,
      'user': user?.toJson(),
      'session': session?.toJson(),
    };
  }

  dynamic toJsonForApi() {
    return {
      'access_token': session?.accessToken,
      'refresh_token': session?.refreshToken,
      'provider_token': session?.providerToken,
      'provider_refresh_token': session?.providerRefreshToken,
    };
  }
}
