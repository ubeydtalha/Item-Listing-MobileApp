import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_application_3/models/team.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/team/team.action.dart';
import 'package:redux/redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamViewModel extends ChangeNotifier {
  final List<Team> teams;
  final bool isLoading;
  final String? error;
  final Store<AppState> store;

  TeamViewModel(
    this.store, {
    required this.teams,
    required this.isLoading,
    this.error,
  });

  static TeamViewModel fromStore(Store<AppState> store) {
    return TeamViewModel(
      store,
      teams: store.state.teamState.teams,
      isLoading: store.state.teamState.isLoading,
      error: store.state.teamState.error,
    );
  }

  Future<void> createTeam(Team team) async {
    
    Team team_ = await saveDB(team);
    store.dispatch(AddTeamAction(team_));
  }

  Future<Team> saveDB(Team team) async {
    Team value = await API.client.createTeam(team);

    if (value.id.isNotEmpty) {
      if (team.image.isNotEmpty) {
        (Supabase.instance.client.storage.from('team_image').upload(
                  '${team.id}/${team.image}.jpg',
                  File('${API.path}/${ImageLocation.team}/${team.image}.jpg'),
                  fileOptions: const FileOptions(
                    cacheControl: '3600',
                    upsert: false,
                  ),
                ))
            .then(
              (value) => print('image uploaded'),
            )
            .catchError((error) => {
                  print(error),
                });
      }
      return value;
    } else {
      throw Exception('Team not saved');
    }
  }

  Future<void> updateTeam(Team team) async {
    if (team.id.isEmpty) {
      // Bu durum sadece ürün state var ve senkronize değilse oluşur
      Team team_ = await saveDB(team);
      store.dispatch(UpdateTeamAction(team_));
      return;
    }

    API.client
        .updateTeam(team)
        .then((value) =>
            Supabase.instance.client.storage.from('team_image').update(
                  '${team.userId}/${team.image}.jpg',
                  File('${API.path}/${ImageLocation.team}/${team.image}.jpg'),
                  fileOptions: const FileOptions(
                    cacheControl: '3600',
                    upsert: false,
                  ),
                ))
        .catchError((error) => throw Exception('Team not updated'));

    store.dispatch(UpdateTeamAction(team));
  }

  Future<void> deleteTeam(Team team) async {
    API.client.deleteTeam(team.id).then((value) {
      Supabase.instance.client.storage.from('team_image').remove(
            ['${team.userId}/${team.image}.jpg',]
          );
      store.dispatch(DeleteTeamAction(team.id));
    }).catchError((error) => throw Exception('Team not deleted'));


  }
}
