
import 'package:flutter_application_3/store/userAuth/userauth.action.dart';
import 'package:redux/redux.dart';
import './userAuth.state.dart';

final userAuthReducer = combineReducers<UserAuthState>([
  TypedReducer<UserAuthState, UserAuthSuccessAction>(_fetchUserAuthSuccess).call,
  TypedReducer<UserAuthState, UserAuthFailedAction>(_fetchUserAuthFailure).call,
  TypedReducer<UserAuthState, UserAuthLoadingAction>(_fetchUserAuthLoading).call,
  TypedReducer<UserAuthState, InitialUserAuthiAction>(_initialUserAuthState).call,
  TypedReducer<UserAuthState, CheckUserAuthAction>(_checkUserAuth).call,
  TypedReducer<UserAuthState, UserAuthLogoutAction>(_logoutUserAuth).call,
]);
	

UserAuthState fetchUserAuthReducer(UserAuthState state, action) {
  
  return userAuthReducer(state, action);
}

UserAuthState _checkUserAuth(UserAuthState state, CheckUserAuthAction action) {
  // api isteği yap ve kullanıcının durumunu kontrol et

  if (state.user != null) {
    return state.copyWith(isLoading: false, error: null);
  }

  return state;
}

UserAuthState _initialUserAuthState(UserAuthState state, dynamic action) {
  return UserAuthState.initial();
}

UserAuthState _fetchUserAuthSuccess(UserAuthState state, UserAuthSuccessAction action) {
  return state.copyWith(isLoading: false, error: null, user: action.user , session: action.session);
}

UserAuthState _fetchUserAuthFailure(UserAuthState state,UserAuthFailedAction action) {
  return state.copyWith(isLoading: false, error: action.error);
}

UserAuthState _fetchUserAuthLoading(UserAuthState state,UserAuthLoadingAction action) {
  return state.copyWith(isLoading: true, error: null);
}

UserAuthState _logoutUserAuth(UserAuthState state, UserAuthLogoutAction action) {
  return UserAuthState.initial();
}