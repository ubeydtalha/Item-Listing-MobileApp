import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/category.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/category/category.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_3/services/imageHandler.dart';


class EditCategoryPage extends StatefulWidget {
  final Category category;

  const EditCategoryPage({super.key, required this.category});

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late Category dummyCategory ;

  @override
  void initState() {
    super.initState();
    dummyCategory = Category.fromJson(widget.category.toJson());
  }

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
      dummyCategory.image = image_.name.split('.').first;
    }
    }


    // dummyCategory.userId = Supabase.instance.client.auth.currentUser!.id;

    await categoryViewModel.updateCategory(dummyCategory);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,CategoryViewModel>(
      converter: (store) => CategoryViewModel.fromStore(store),
      builder: (context , CategoryViewModel categoryViewModel) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Category'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => pickImage(),
                    child: dummyCategory.image.isNotEmpty ? Image.file(
                      File('${API.path}/${ImageLocation.category}/${dummyCategory.image}.jpg'),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.category.name,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                    ),
                    onChanged: (value) {
                      dummyCategory.name = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.category.order.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Category Order',
                    ),
                    onChanged: (value) {
                      dummyCategory.order = int.parse(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
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
