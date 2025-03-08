import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/team.dart';
import 'package:flutter_application_3/models/user.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TeamAddMemberPage extends StatefulWidget {

  final  Map<String,dynamic> arguments;
  // Team? team;

  const TeamAddMemberPage({super.key, required this.arguments});

  @override
  _TeamAddMemberPageState createState() => _TeamAddMemberPageState();
}

class _TeamAddMemberPageState extends State<TeamAddMemberPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<User?> _users = [];
  List<User?> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = _users;
  }

  void _filterUsers(String query) async {
    final users = await API.client.inviteUserAutoComplete(query);
    setState(() {
      _filteredUsers = users.cast<User?>();
    });
  }

  void _inviteUser(User? user, InviteUserViewModel vm) async {
    vm.invitedUser = user;
    await vm.inviteUser(team :widget.arguments['team']);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitation sent to $user')),
    );
    vm.invitedUser = null;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InviteUserViewModel>(
        converter: (store) => InviteUserViewModel.fromStore(store),
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Team Member'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Users',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterUsers,
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_filteredUsers[index]?.username ?? ''),
                          trailing: ElevatedButton(
                            onPressed: () =>
                                _inviteUser(_filteredUsers[index], vm),
                            child: const Text('Invite'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class InviteUserViewModel {
  final Store<AppState> store;
  User? invitedUser;

  InviteUserViewModel(this.store);

  factory InviteUserViewModel.fromStore(Store<AppState> store) {
    return InviteUserViewModel(store);
  }

  Future<bool> inviteUser(
      {required Team? team}
  ) async {
    if (invitedUser != null) {
      return await API.client.invite(
        teamId: team!.id,
        invitedUserId: invitedUser!.id,
        userId: store.state.userAuthState.user!.id,
      );
    }
    return false;
  }
}
