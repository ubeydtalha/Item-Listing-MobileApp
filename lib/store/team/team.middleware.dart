
import 'package:flutter_application_3/store/app.state.dart';
import 'package:redux/redux.dart';

Middleware<AppState> getTeam() {
	return (Store<AppState> store, action, NextDispatcher dispatch) async {
	dispatch(action);
	try {
		
	} catch (error) {
		// TODO: API Error handling
		print(error);
	}
	};
}
	