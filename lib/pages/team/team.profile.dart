import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/response.base.dart';
import 'package:flutter_application_3/models/team.dart';
import 'package:flutter_application_3/models/teams_user.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/teamsUser/teamsuser.action.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/iterables.dart';
import 'package:redux/redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamProfilePage extends StatefulWidget {
  final Team team;
  const TeamProfilePage({super.key, required this.team});

  @override
  State<TeamProfilePage> createState() => _TeamProfilePageState();
}

class _TeamProfilePageState extends State<TeamProfilePage> {
  bool isLoading = true;
  List<Map<String, Object>?> actions = [];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TeamProfileViewModel>(
      onInit: (store) async {
        await TeamProfileViewModel.getMyTeamsUserResponse(widget.team.id);

        for (var user in TeamProfileViewModel.myTeamsUserResponse.teamsUser!) {
          store.dispatch(AddTeamsUserAction(teamsUser: user));
        }

        isLoading = false;
      },
      converter: (store) => TeamProfileViewModel(store, team: widget.team),
      builder: (context, vm) {
        return Scaffold(
          body: Center(
            child: ListView(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      color: const Color.fromARGB(0, 158, 158, 158),
                    ),
                    Stack(
                      children: [
                        Hero(
                          tag: 'profile${widget.team.id}',
                          child: Container(
                              height: 200,
                              width: double.infinity,
                              // color: const Color.fromARGB(255, 164, 38, 38),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: widget.team
                                    .getImage(
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                    .image,
                              ))),
                        ),
                        Positioned(
                          top: 200 - 40,
                          left: MediaQuery.of(context).size.width - 155,
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .highlightColor
                                  .withOpacity(0.8),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: TextButton.icon(
                                onPressed: () => {
                                      Navigator.pushNamed(context, '/team/add',
                                          arguments: {"team": widget.team})
                                    },
                                label: Text(
                                  'Add Member',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                icon: const Icon(Icons.add_circle)),
                          ),
                        ),
                        Positioned(
                          top: 200 - 80,
                          left: MediaQuery.of(context).size.width - 105,
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .highlightColor
                                  .withOpacity(0.8),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: TextButton.icon(
                                onPressed: () => onSave(vm.store),
                                label: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                icon: const Icon(Icons.save)),
                          ),
                        ),
                        Positioned(
                            child: Container(
                          child: TextButton.icon(
                              onPressed: () => Navigator.pop(context, "retype"),
                              label: const Text("Back"),
                              icon: const Icon(Icons.arrow_back)),
                        ))
                      ],
                    ),
                    Positioned(
                      top: 100,
                      left: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            child: widget.team.getImage( 
                              height: 150,
                            width: 150,),

                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(75),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              ),
                            ),
                          
                          const SizedBox(width: 10),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.team.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // SizedBox(height: 5),
                                Text(
                                  widget.team.isPublic ? 'Public' : 'Private',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 6, 122, 95),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                for (var user_ in TeamProfileViewModel
                    .myTeamsUserResponse.teamsUser!.nonNulls)
                  ListTile(
                    title: Text(TeamProfileViewModel.myTeamsUserResponse.users!
                        .where((element) => element.id == user_.userId)
                        .first
                        .email),
                    subtitle: Text(user_.role.name),
                    trailing: vm.haveIPerm() &&
                            (user_.role != TeamRole.OWNER &&
                                user_.role != TeamRole.CANDIDATE)
                        ? SizedBox(
                            width:
                                150, // Adjust the width as per your layout needs
                            child: DropdownMenu(
                              onSelected: (value) {
                                actions.add(value);
                              },
                              label: const Text("Actions"),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                    label: "Upgrade Role",
                                    value: {
                                      "role": user_.role,
                                      "userId": user_.userId,
                                      "teamId": widget.team.id,
                                      "action": TeamsUserUpdateType.UPGRADE
                                    },
                                    enabled: user_.role != TeamRole.ADMIN),
                                DropdownMenuEntry(
                                    label: "Downgrade Role",
                                    value: {
                                      "role": user_.role,
                                      "userId": user_.userId,
                                      "teamId": widget.team.id,
                                      "action": TeamsUserUpdateType.DOWNGRADE
                                    }),
                                DropdownMenuEntry(label: "Remove User", value: {
                                  "role": user_.role,
                                  "userId": user_.userId,
                                  "teamId": widget.team.id,
                                  "action": TeamsUserUpdateType.REMOVE
                                }),
                              ],
                            ),
                          )
                        : user_.role == TeamRole.CANDIDATE &&
                                vm.store.state.userAuthState.user?.id ==
                                    user_.userId
                            ? SizedBox(
                                width:
                                    100, // Set a fixed width for the action buttons
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => {
                                        API.client.acceptInvite(
                                          teamId: widget.team.id,
                                          userId: user_.userId,
                                        ),
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TeamProfilePage(
                                                        team: widget.team)),
                                            (route) => false),
                                      },
                                      icon: const Icon(Icons.approval),
                                    ),
                                    IconButton(
                                      onPressed: () => {
                                        API.client.rejectInvite(
                                          userId: user_.userId,
                                          teamId: widget.team.id,
                                        ),
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TeamProfilePage(
                                                        team: widget.team)),
                                            (route) => false),
                                      },
                                      icon: const Icon(Icons.cancel),
                                    ),
                                  ],
                                ),
                              )
                            : null,
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  void onSave(Store<AppState> store) {
    try {
      for (var element in actions) {
        TeamsUser currentTeamsUser = store.state.teamsUserState.teamsUser
            .where((element_) => element_.userId == element?["userId"])
            .first;
        switch (element!["action"]) {
          case TeamsUserUpdateType.UPGRADE:
            API.client.updateTeamsUser(currentTeamsUser.copyWith(
                role: currentTeamsUser.getUpgradeRole()));
            store.dispatch(UpdateTeamsUserAction(
                teamsUser: currentTeamsUser.copyWith(
                    role: currentTeamsUser.getUpgradeRole())));
            break;
          case TeamsUserUpdateType.DOWNGRADE:
            API.client.updateTeamsUser(currentTeamsUser.copyWith(
                role: currentTeamsUser.getDowngradeRole()));
            store.dispatch(UpdateTeamsUserAction(
                teamsUser: currentTeamsUser.copyWith(
                    role: currentTeamsUser.getDowngradeRole())));
            break;
          case TeamsUserUpdateType.REMOVE:
            API.client.deleteTeamsUser(
                userId: currentTeamsUser.id, teamId: currentTeamsUser.teamId);
            store.dispatch(DeleteTeamsUserAction(teamsUser: currentTeamsUser));
            break;
          default:
        }
      }
    } catch (e) {
      print(e);
    } finally {
      actions.clear();
    }
  }
}

class TeamProfileViewModel {
  final Team team;
  static MyTeamsUserResponse myTeamsUserResponse =
      MyTeamsUserResponse.initial();
  final Store<AppState> store;
  static bool isLoading = true;
  // final List<TeamsUser> teamUsers;

  TeamProfileViewModel(this.store, {required this.team});

  static Future<bool> getMyTeamsUserResponse(String teamId) async {
    myTeamsUserResponse = await API.client.getTeamsUser(
      teamId,
    );
    isLoading = false;

    return myTeamsUserResponse.users!.isEmpty;
    // store.dispatch(TeamsUserSuccessAction(isSuccess: 1));
  }

  bool haveIPerm() {
    return [TeamRole.ADMIN, TeamRole.OWNER].contains(myTeamsUserResponse
        .teamsUser
        ?.where(
            (element) => element.userId == store.state.userAuthState.user?.id)
        .first
        .role);
  }

  bool amIOwner() {
    return myTeamsUserResponse.teamsUser
            ?.where((element) =>
                element.userId == store.state.userAuthState.user?.id)
            .first
            .role ==
        TeamRole.OWNER;
  }
}
