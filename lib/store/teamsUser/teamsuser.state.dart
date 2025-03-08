
import 'package:flutter_application_3/models/teams_user.dart';

class TeamsUserState {
	final bool loading;
	final String error;
  final List<TeamsUser> teamsUser;

	TeamsUserState(this.loading, this.error, this.teamsUser);

	factory TeamsUserState.initial() => TeamsUserState(false, '', []);

	TeamsUserState copyWith({bool? loading, String? error, List<TeamsUser>? teamsUser}) {
    return TeamsUserState(
      loading ?? this.loading,
      error ?? this.error,
      teamsUser ?? this.teamsUser,
    );
  }

	@override
	bool operator ==(other) =>
		identical(this, other) ||
		other is TeamsUserState &&
			runtimeType == other.runtimeType &&
			loading == other.loading &&
			error == other.error &&
      teamsUser == other.teamsUser;

	@override
	int get hashCode =>
		super.hashCode ^ runtimeType.hashCode ^ loading.hashCode ^ error.hashCode ^ teamsUser.hashCode;

	@override
	String toString() => "TeamsUserState { loading: $loading,  error: $error}";

  static TeamsUserState fromJson(dynamic json) {
    return json != null
      ? TeamsUserState(
        json['loading'],
        json['error'],
        List<TeamsUser>.from(json['teamsUser'].map((teamsUser) => TeamsUser.fromJson(teamsUser)))
      )
      : TeamsUserState.initial();
  }

  dynamic toJson() => {
    'loading': loading,
    'error': error,
    'teamsUser': teamsUser.map((teamsUser) => teamsUser.toJson()).toList(),
  };

  

  
}
	  