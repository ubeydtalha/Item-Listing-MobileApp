import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/product.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/product/product.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:flutter_application_3/services/imageHandler.dart';

class EditProduct extends StatefulWidget {
  final Product product;

  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late Product product;

  @override
  void initState() {
    super.initState();
    product = Product.fromJson(widget.product.toJson());
  }

  final ImagePicker _picker = ImagePicker();
  void pickImage(ProductViewModel productViewModel) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      requestFullMetadata: false,
    );
    if (image != null) {
      widget.product.images.add(image.name.split('.').first);
    }
  }

  void onSaved(ProductViewModel productViewModel) async {
    await productViewModel.updateProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductViewModel>(
        converter: (store) => ProductViewModel.fromStore(store),
        builder: (context, ProductViewModel productViewModel) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Product'),
            ),
            body: ListView(
              children: [
                // select image
                CarouselSlider(
                  items: [
                    for (var e in product.images)
                      Image.file(
                        File('${API.path}/products/${e.split('.').first}.jpg'),
                        errorBuilder: (context, error, stackTrace) =>
                            Image.network(
                          Supabase.instance.client.storage
                              .from('product_image')
                              .getPublicUrl('${product.userId}/$e.jpg'),
                          width: 600,
                          height: 600,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    TextButton.icon(
                      onPressed: () async => {pickImage(productViewModel)},
                      label: const Text('Add image'),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                  options: CarouselOptions(
                    height: 250,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.65,
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
                      onChanged: (value) => setState(() {
                            product.name = value;
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      initialValue: product.barcode,
                      decoration: const InputDecoration(
                        labelText: 'Barcode',
                      ),
                      onChanged: (value) => setState(() {
                            product.barcode = value;
                          })),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownMenu(
                      label: const Text('Category'),
                      width: MediaQuery.of(context).size.width ,
                      dropdownMenuEntries:
                          productViewModel.store.state.categoryState.categories.where(
                              (element) =>
                                  element.teamId ==
                                  productViewModel.store.state.teamState.selectedTeam?.id
                          )
                              .map((e) => DropdownMenuEntry(
                                    label: e.name,
                                    value: e.id,
                                  ))
                              .toList(),
                      onSelected: (value) => product.categoryId = value!,
                      initialSelection: product.categoryId,
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      initialValue: product.price.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      onChanged: (value) => setState(() {
                            product.price = double.parse(value);
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      initialValue: product.description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      onChanged: (value) => setState(() {
                            product.description = value;
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async => {
                      onSaved(productViewModel),
                      Navigator.pop(context),
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
