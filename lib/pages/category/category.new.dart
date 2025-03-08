import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/category.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/category/category.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_3/services/imageHandler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageLocation {
  static const String category = 'category';
  static const String product = 'product';
  static const String team = 'team';
  static const String user = 'user';
}


class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  _CreateCategoryPageState createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  
  Category category = Category(
    id: "0",
    name: '',
    image: '',
    order: 0, 
    userId: '',
  );
  
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

  void onSaved(CategoryViewModel categoryViewModel) async {
    if (dummyImage != null) {
    XFile? image_ = (await ImageHandler.saveImage(dummyImage!, ImageLocation.category));
    if (image_ != null) {
      category.image = image_.name.split('.').first;
    }
    }


    category.userId = Supabase.instance.client.auth.currentUser!.id;

    await categoryViewModel.saveCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,CategoryViewModel>(
      converter: (store) => CategoryViewModel.fromStore(store),
      builder: (context, CategoryViewModel categoryViewModel) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Category'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dummyImage != null ? Image.file(
                    File(dummyImage!.path),
                    fit: BoxFit.fill,
                    height: 200,
                    width: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ) : TextButton.icon(
                  onPressed: () async => {pickImage()},
                  label: const Text('Add image'),
                  icon: const Icon(Icons.add),
                ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                    ),
                    onChanged: (value) {
                      category.name = value;
                    },
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Category Order',
                    ),
                    onChanged: (value) {
                      category.order = int.parse(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      category.teamId = categoryViewModel.store.state.teamState.selectedTeam!.id;
                      onSaved(categoryViewModel);
                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}