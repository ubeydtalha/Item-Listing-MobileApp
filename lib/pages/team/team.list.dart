import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/team/team.grid.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/team/team.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TeamList extends StatelessWidget {
  const TeamList({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,TeamViewModel>(
      
        converter: (store) => TeamViewModel.fromStore(store),
        builder: (context, TeamViewModel teamViewModel) => Column(
          children: [
            const SizedBox(height: 15),
            Expanded(
                child: GridView.count(
              scrollDirection: Axis.vertical,
              crossAxisCount: 3,
              padding: const EdgeInsets.all(10),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: teamViewModel.isLoading ?   [const Center(child: CircularProgressIndicator(),)]
              : [
                for (var team in teamViewModel.teams)
                  TeamPreview(team: team),
              ],
            ))
          ],
        )
    );
  }
}