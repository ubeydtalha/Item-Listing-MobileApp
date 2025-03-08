
import 'package:supabase_flutter/supabase_flutter.dart';


class InitialUserAuthiAction {
  InitialUserAuthiAction();
  @override
  String toString() {
  return 'InitialUserAuthiAction';
  }
}

class CheckUserAuthAction {
  CheckUserAuthAction();
  @override
  String toString() {
  return 'CheckUserAuthAction';
  }
}

class UserAuthSuccessAction {
  final User? user; 
  final Session? session;
	final int isSuccess;

	UserAuthSuccessAction({this.session, required this.user, required this.isSuccess});
	@override
	String toString() {
	return 'UserAuthSuccessAction { isSuccess: $isSuccess }';
	}
}

class UserAuthFailedAction {
	final String error;

	UserAuthFailedAction({required this.error});

	@override
	String toString() {
	return 'UserAuthFailedAction { error: $error }';
	}
}

class UserAuthLoadingAction {
  final bool isLoading;

  UserAuthLoadingAction({required this.isLoading});

  @override
  String toString() {
  return 'UserAuthLoadingAction { isLoading: $isLoading }';
  }
}

class UserAuthLogoutAction {
  UserAuthLogoutAction();
  @override
  String toString() {
  return 'UserAuthLogoutAction';
  }
}