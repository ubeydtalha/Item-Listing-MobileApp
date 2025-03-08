import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_3/models/product.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/services/imageHandler.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/product/product.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductState();
}

class _NewProductState extends State<NewProductPage> {
  final ImagePicker _picker = ImagePicker();

  List<XFile> dummyImages = [];

  void pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      requestFullMetadata: false,
    );
    if (image != null) {
      setState(() {
        dummyImages.add(image);
      });
    }
    } catch (e) {
      if (e is PlatformException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${e.message}'),
        ));
      }
      
    }
    
  }

  void onSaved(ProductViewModel productViewModel) async {
    for (var image in dummyImages) {
      XFile? image_ = (await ImageHandler.saveImage(image, ImageLocation.product));
      if (image_ != null) {
        product.images.add(image_.name.split('.').first);
      }
    }

    if (product.images.isNotEmpty) {
      product.image = product.images[0];
    }

    product.userId = Supabase.instance.client.auth.currentUser!.id;

    await productViewModel.saveProduct(product);
  }

  Product product = Product(
    id: "",
    name: '',
    secondName: '',
    barcode: '',
    categoryId: '00000000-0000-0000-0000-000000000000',
    price: 0,
    quantity: 0,
    description: '',
    image: '',
    images: [],
    stock: 0,
    userId: '',
    
  );

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductViewModel>(
      converter: (store) => ProductViewModel.fromStore(store),
      builder: (context, ProductViewModel productViewModel) => Scaffold(
        appBar: AppBar(
          title: Text('New Product - ${productViewModel.store.state.teamState.selectedTeam?.name}'),
        ),
        body: ListView(
          children: [
            // select image
            CarouselSlider(
              items: [
                // for (var image in product.images)
                //   Image.network(
                //     image,
                //     fit: BoxFit.fill,
                //     errorBuilder: (context, error, stackTrace) {
                //       return Icon(Icons.error);
                //     },
                //   ),
                for (var image in dummyImages)
                  Image.file(
                    File(image.path),
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                TextButton.icon(
                  onPressed: () async => {pickImage()},
                  label: const Text('Add image'),
                  icon: const Icon(Icons.add),
                ),
              ],
              options: CarouselOptions(
                height: 250,
                aspectRatio: 16 / 9,
                viewportFraction: 0.55,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: product.name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) => product.name = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: product.barcode,
                decoration: const InputDecoration(
                  labelText: 'Barcode',
                ),
                onChanged: (value) => product.barcode = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownMenu(
            dropdownMenuEntries: 
              productViewModel.store.state.categoryState.categories.where(
                (element) => element.teamId == productViewModel.store.state.teamState.selectedTeam?.id
              ).map((e) => DropdownMenuEntry(
                label: e.name,
                value: e.id,
              )).toList(),
              onSelected: (value) => product.categoryId = value!,
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: product.price.toString(),
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
                onChanged: (value) => product.price = double.parse(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: product.description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) => product.description = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async => {
                  product.teamId = productViewModel.store.state.teamState.selectedTeam!.id,
                  onSaved(productViewModel),
                  
                  },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
