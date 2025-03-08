
import 'package:flutter_application_3/store/teamsUser/teamsuser.action.dart';
import 'package:redux/redux.dart';
import './teamsUser.state.dart';

final teamsUserReducer = combineReducers<TeamsUserState>([
  TypedReducer<TeamsUserState, TeamsUserSuccessAction>(fetchTeamsUserSuccessReducer).call,
  TypedReducer<TeamsUserState, TeamsUserFailedAction>(fetchTeamsUserFailureReducer).call,
  TypedReducer<TeamsUserState, TeamsUserLoadingAction>(fetchTeamsUserLoadingReducer).call,
  TypedReducer<TeamsUserState, AddTeamsUserAction>(addTeamsUserReducer).call,
  TypedReducer<TeamsUserState, UpdateTeamsUserAction>(updateTeamsUserReducer).call,
  TypedReducer<TeamsUserState, DeleteTeamsUserAction>(deleteTeamsUserReducer).call,
]);

TeamsUserState fetchteamsUserReducer(TeamsUserState state, action) {
  return teamsUserReducer(state, action);
}

TeamsUserState addTeamsUserReducer(TeamsUserState state,AddTeamsUserAction action) {

  bool hasIt = state.teamsUser.any((element) => element.id == action.teamsUser.id);
  if (hasIt) {
    return state;
  }
  return state.copyWith(teamsUser: [...state.teamsUser, action.teamsUser]);
}


TeamsUserState updateTeamsUserReducer(TeamsUserState state, UpdateTeamsUserAction action) {
  final teamsUser = state.teamsUser.map((teamsUser) => teamsUser.id == action.teamsUser.id ? action.teamsUser : teamsUser).toList();
  return state.copyWith(teamsUser: teamsUser);
}

TeamsUserState deleteTeamsUserReducer(TeamsUserState state, DeleteTeamsUserAction action) {
  final teamsUser = state.teamsUser.where((teamsUser) => teamsUser.id != action.teamsUser.id).toList();
  return state.copyWith(teamsUser: teamsUser);
}

TeamsUserState fetchTeamsUserSuccessReducer(TeamsUserState state, TeamsUserSuccessAction action) {
  return state.copyWith(error: '', loading: false);
}

TeamsUserState fetchTeamsUserFailureReducer(TeamsUserState state, TeamsUserFailedAction action) {
  return state.copyWith(error: action.error, loading: false);
}

TeamsUserState fetchTeamsUserLoadingReducer(TeamsUserState state, TeamsUserLoadingAction action) {
  return state.copyWith(error: '', loading: true);
}