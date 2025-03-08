


import 'package:flutter_application_3/models/team.dart';
import 'package:flutter_application_3/models/teams_user.dart';
import 'package:flutter_application_3/models/user.dart';

class MyTeamsUserResponse {
  List<TeamsUser>? teamsUser;
  List<User>? users;
  Team? team;

  MyTeamsUserResponse({
    required this.teamsUser,
    required this.users,
    required this.team,
  });

  factory MyTeamsUserResponse.initial() {
    return MyTeamsUserResponse(
      teamsUser: [],
      users: [],
      team: Team.initial(),
    );
  }

  factory MyTeamsUserResponse.fromJson(Map<String, dynamic> json) {
    return MyTeamsUserResponse(
      teamsUser: List<TeamsUser>.from(json['teams_user'].map((teamsUser) => TeamsUser.fromJson(teamsUser))),
      users: List<User>.from(json['users'].map((user) => User.fromJson(user))),
      team: Team.fromJson(json['team']),
    );
  }
}

