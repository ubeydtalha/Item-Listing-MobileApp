
import 'package:flutter_application_3/models/teams_user.dart';

class TeamsUserAction {

	@override
	String toString() {
	return 'TeamsUserAction { }';
	}
}

class TeamsUserSuccessAction {
	final int isSuccess;

	TeamsUserSuccessAction({required this.isSuccess});
	@override
	String toString() {
	return 'TeamsUserSuccessAction { isSuccess: $isSuccess }';
	}
}

class TeamsUserFailedAction {
	final String error;

	TeamsUserFailedAction({required this.error});

	@override
	String toString() {
	return 'TeamsUserFailedAction { error: $error }';
	}
}

class TeamsUserLoadingAction {
  @override
  String toString() {
  return 'TeamsUserLoadingAction { }';
  }
}
	

class AddTeamsUserAction {
  final TeamsUser teamsUser;

  AddTeamsUserAction({required this.teamsUser});

  @override
  String toString() {
    return 'AddTeamsUserAction { teamsUser: $teamsUser }';
  }

}

class DeleteTeamsUserAction {
  final TeamsUser teamsUser;

  DeleteTeamsUserAction({required this.teamsUser});

  @override
  String toString() {
    return 'DeleteTeamsUserAction { teamsUser: $teamsUser }';
  }

}

class UpdateTeamsUserAction {
  final TeamsUser teamsUser;

  UpdateTeamsUserAction({required this.teamsUser});

  @override
  String toString() {
    return 'UpdateTeamsUserAction { teamsUser: $teamsUser }';
  }

}