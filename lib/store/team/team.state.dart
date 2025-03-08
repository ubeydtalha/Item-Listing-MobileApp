
import 'package:flutter_application_3/models/team.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamState {
  final List<Team> teams;
  final Team? selectedTeam;
  final bool isLoading;
  final String? error;
  

  TeamState({
    required this.teams,
    required this.selectedTeam,
    required this.isLoading,
    required this.error,
  });

  factory TeamState.initial() => TeamState(
        teams: [],
        selectedTeam: Team(id: '00000000-0000-0000-0000-000000000000', name: 'Personal', userId: Supabase.instance.client.auth.currentUser?.id ?? ''),
        isLoading: false,
        error: null,
      );

  TeamState copyWith({
    List<Team>? teams,
    Team? selectedTeam,
    bool? isLoading,
    String? error,
  }) {
    return TeamState(
      teams: teams ?? this.teams,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is TeamState &&
          runtimeType == other.runtimeType &&
          teams == other.teams &&
          selectedTeam == other.selectedTeam &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^ teams.hashCode ^ selectedTeam.hashCode ^ isLoading.hashCode ^ error.hashCode;

  @override
  String toString() {
    return "TeamState { teams: $teams selectedTeam: $selectedTeam isLoading: $isLoading error: $error }";
  }

  static TeamState fromJson(dynamic json) {
    return json != null
        ? TeamState(
            teams: (json['teams'] as List).map((e) => Team.fromJson(e)).toList().cast<Team>(),
            selectedTeam: json['selectedTeam'] != null ? Team.fromJson(json['selectedTeam']) : null,
            isLoading: json['isLoading'],
            error: json['error'],
          )
        : TeamState.initial();
  }

  dynamic toJson() {
    return {
      'teams': teams.map((e) => e.toJson()).toList(),
      'selectedTeam': selectedTeam?.toJson(),
      'isLoading': isLoading,
      'error': error,
    };
  }
}
	  