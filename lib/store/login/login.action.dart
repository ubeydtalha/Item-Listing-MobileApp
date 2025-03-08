

class LoginAction {

	@override
	String toString() {
	return 'LoginAction { }';
	}
}

class LoginSuccessAction {
	final int isSuccess;

	LoginSuccessAction({required this.isSuccess});
	@override
	String toString() {
	return 'LoginSuccessAction { isSuccess: $isSuccess }';
	}
}

class LoginFailedAction {
	final String error;

	LoginFailedAction({required this.error});

	@override
	String toString() {
	return 'LoginFailedAction { error: $error }';
	}
}
	