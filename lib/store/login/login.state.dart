
class LoginState {
	final bool loading;
	final String error;

	LoginState(this.loading, this.error);

	factory LoginState.initial() => LoginState(false, '');

	LoginState copyWith({bool? loading, String? error}) =>
		LoginState(loading ?? this.loading, error ?? this.error);

	@override
	bool operator ==(other) =>
		identical(this, other) ||
		other is LoginState &&
			runtimeType == other.runtimeType &&
			loading == other.loading &&
			error == other.error;

	@override
	int get hashCode =>
		super.hashCode ^ runtimeType.hashCode ^ loading.hashCode ^ error.hashCode;

	@override
	String toString() => "LoginState { loading: $loading,  error: $error}";

  static LoginState fromJson(dynamic json) {
    return LoginState(
      json['loading'] as bool,
      json['error'] as String,
    );
  }

  dynamic toJson() {
    return {
      'loading': loading,
      'error': error,
    };
  }
}
	  