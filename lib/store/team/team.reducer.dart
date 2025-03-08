
import 'package:flutter_application_3/models/team.dart';
import 'package:flutter_application_3/store/team/team.action.dart';
import 'package:redux/redux.dart';
import './team.state.dart';

final teamReducer = combineReducers<TeamState>([
  TypedReducer<TeamState, TeamSuccessAction>(_fetchTeamsSuccess).call,
  TypedReducer<TeamState, TeamFailedAction>(_fetchTeamsFailure).call,
  TypedReducer<TeamState, TeamsLoadingAction>(_fetchTeamsLoading).call,
  TypedReducer<TeamState, AddTeamAction>(addTeamReducer).call,
  TypedReducer<TeamState, UpdateTeamAction>(updateTeamReducer).call,
  TypedReducer<TeamState, DeleteTeamAction>(deleteTeamReducer).call,
  TypedReducer<TeamState, SelectTeamAction>(selectTeamReducer).call,
  TypedReducer<TeamState, AddBulkTeamsAction>(addBulkTeamReducer).call,
]);
	

TeamState fetchTeamsReducer(TeamState state, action) {
  return teamReducer(state, action);
}

TeamState _fetchTeamsSuccess(
    TeamState state, TeamSuccessAction action) {
  return state.copyWith(
      isLoading: false, error: null, teams: action.teams);
}

TeamState _fetchTeamsFailure(
    TeamState state, TeamFailedAction action) {
  return state.copyWith(isLoading: false, error: action.error);
}

TeamState _fetchTeamsLoading(
    TeamState state, TeamsLoadingAction action) {
  return state.copyWith(isLoading: true, error: null);
}

TeamState addTeamReducer(TeamState state, AddTeamAction action) {
  final teams = List<Team>.from(state.teams);
  
  bool hasIt = teams.any((element) => element.id == action.team.id);
  if (!hasIt) {
    teams.add(action.team);
  }
  return state.copyWith(teams: teams);
}

TeamState updateTeamReducer(TeamState state, UpdateTeamAction action) {
  final teams = List<Team>.from(state.teams);
  final index = teams.indexWhere((element) => element.id == action.team.id);
  teams[index] = action.team;
  return state.copyWith(teams: teams);
}

TeamState deleteTeamReducer(TeamState state, DeleteTeamAction action) {
  final teams = List<Team>.from(state.teams);
  teams.removeWhere((element) => element.id == action.id);
  return state.copyWith(teams: teams);
}

TeamState selectTeamReducer(TeamState state, SelectTeamAction action) {
  return state.copyWith(selectedTeam: action.team);
}

TeamState addBulkTeamReducer(TeamState state, AddBulkTeamsAction action) {
  final teams = action.teams;
  return state.copyWith(teams: teams);
}