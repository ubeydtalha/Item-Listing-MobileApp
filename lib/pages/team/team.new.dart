import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/team.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/team/team.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_3/services/imageHandler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewTeamPage extends StatefulWidget {
  const NewTeamPage({super.key});

  @override
  State<NewTeamPage> createState() => _NewTeamPageState();
}

class _NewTeamPageState extends State<NewTeamPage> {
  late Team team;

  XFile? dummyImage;

  final ImagePicker _picker = ImagePicker();

  void pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      requestFullMetadata: false,
    );
    if (image != null) {
      setState(() {
        dummyImage = XFile(image.path);
      });
    }
  }

  void onSaved(TeamViewModel teamViewModel) async {
    if (dummyImage != null) {
      XFile? image_ =
          (await ImageHandler.saveImage(dummyImage!, ImageLocation.team));
      if (image_ != null) {
        team.image = image_.name.split('.').first;
      }
    }

    team.userId = Supabase.instance.client.auth.currentUser!.id;

    try {
      await teamViewModel.createTeam(team);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 2),
      );
      
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TeamViewModel>(
        onInit: (store) => team = Team(
              id: '',
              name: '',
              image: '',
              userId: '',
            ),
        converter: (store) => TeamViewModel.fromStore(store),
        builder: (context, TeamViewModel teamViewModel) => Scaffold(
              appBar: AppBar(
                title: const Text('New Team'),
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: dummyImage != null
                        ? Image.file(
                            File(dummyImage!.path),
                            fit: BoxFit.fill,
                            height: 200,
                            width: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                Supabase.instance.client.storage
                                    .from('team_image')
                                    .getPublicUrl(
                                        '${team.id}/${team.image}.jpg'),
                                fit: BoxFit.fill,
                                height: 200,
                                width: 200,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.error),
                                  );
                                },
                              );
                            },
                          )
                        : TextButton.icon(
                            onPressed: () async => {pickImage()},
                            label: const Text('Add image'),
                            icon: const Icon(Icons.add),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Team Name',
                      ),
                      onChanged: (value) {
                        team.name = value;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        // is public?
                        const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('Is Public?'),
                        Switch(
                          value: team.isPublic,
                          onChanged: (value) {
                            setState(() {
                              team.isPublic = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        onSaved(teamViewModel);
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ));
  }
}
