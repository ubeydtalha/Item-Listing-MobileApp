
import 'package:flutter_application_3/models/team.dart';

class TeamAction {

	@override
	String toString() {
	return 'TeamAction { }';
	}
}

class TeamSuccessAction {
	final int isSuccess;
  final List<Team> teams;

	TeamSuccessAction(this.teams, {required this.isSuccess});
	@override
	String toString() {
	return 'TeamSuccessAction { isSuccess: $isSuccess }';
	}
}

class TeamFailedAction {
	final String error;

	TeamFailedAction({required this.error});

	@override
	String toString() {
	return 'TeamFailedAction { error: $error }';
	}
}
	


class TeamsLoadingAction {
  final int isLoading;

  TeamsLoadingAction({this.isLoading = 1});

  factory TeamsLoadingAction.trueLoading() => TeamsLoadingAction(isLoading: 1);
  factory TeamsLoadingAction.falseLoading() => TeamsLoadingAction(isLoading: 0);

  @override
  String toString() {
  return 'TeamsLoadingAction { }';
  }
}

class AddTeamAction {
  final Team team;

  AddTeamAction(this.team);

  @override
  String toString() {
  return 'AddTeamAction { team: $team }';
  }
}

class SelectTeamAction {
  final Team team;

  SelectTeamAction(this.team);

  @override
  String toString() {
  return 'SelectTeamAction { team: $team }';
  }
}

class UpdateTeamAction {
  final Team team;

  UpdateTeamAction(this.team);

  @override
  String toString() {
  return 'UpdateTeamAction { team: $team }';
  }
}

class DeleteTeamAction {
  final String id;

  DeleteTeamAction(this.id);

  @override
  String toString() {
  return 'DeleteTeamAction { id: $id }';
  }
}

class AddBulkTeamsAction {
  final List<Team> teams;

  AddBulkTeamsAction(this.teams);

  @override
  String toString() {
  return 'AddBulkTeamsAction { teams: $teams }';
  }
}