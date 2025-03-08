import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/userAuth/userauth.action.dart';
import 'package:redux/redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class UserAuthViewModel {
  final bool isLoading;
  final String? error;
  final User? user ;
  final Session? session;
  final Store<AppState> store;


  UserAuthViewModel(this.store,{ this.session, 
    required this.isLoading,
    required this.error,
    required this.user,
  });

  static UserAuthViewModel fromStore(Store<AppState> store) {
    return UserAuthViewModel(
      store,
      isLoading: store.state.userAuthState.isLoading,
      error: store.state.userAuthState.error,
      user: store.state.userAuthState.user,
      session: store.state.userAuthState.session,
    );
  }

  void userLogout() {
    store.dispatch(UserAuthLogoutAction());
  }

}