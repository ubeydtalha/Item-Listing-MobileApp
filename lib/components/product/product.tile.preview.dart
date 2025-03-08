import 'dart:io';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/product.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/pages/product/product.edit.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// class ListProductPreview extends StatelessWidget {

//   final Product product;

//   const ListProductPreview({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundImage: NetworkImage(
//           product.image,
//         ),
//         onBackgroundImageError: (exception, stackTrace) {
//           CircleAvatar(
//             child: Text(product.name[0]),
//           );
//         },
//         radius: 25,
//       ),
//       title: Text(product.name),
//       subtitle: Text('Code: ${product.barcode}, Category: ${product.category}'),
//       trailing: const Icon(Icons.more_vert),
//     );
//   }
// }

class ListProductPreview extends StatefulWidget {
  final Product product;

  const ListProductPreview({super.key, required this.product});

  @override
  State<ListProductPreview> createState() => _ListProductPreviewState();
}

class _ListProductPreviewState extends State<ListProductPreview> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,ProductTileViewModel>(
      converter: (store) => ProductTileViewModel(store,product : widget.product),
      builder: (context, vm) {
        return Material(
          child: InkWell(
            onDoubleTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => EditProduct(product: widget.product)),
            ),
            onLongPress: () => print('Product ${widget.product.name} pressed'),
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                contentPadding: const EdgeInsets.all(0),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                title: Text(widget.product.name),
                content: SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.8,
                  // width: MediaQuery.of(context).size.width * 0.8,
                  child: CarouselSlider(
                    items: widget.product.images
                        .map((e) => Hero(
                              tag: e,
                              child: Image.file(
                                File('${API.path}/${ImageLocation.product}/${e.split('.').first}.jpg'),
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.network(
                                  Supabase.instance.client.storage
                                      .from('product_image')
                                      .getPublicUrl(
                                          '${widget.product.userId}/$e.jpg'),
                                  width: 600,
                                  height: 600,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ))
                        .toList(),
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.9,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: false,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
                actions: [
                  Column(
                    children: [
                      Text('Code: ${widget.product.barcode}'),
                      Text('Category: ${vm.store.state.categoryState.categories
                                    .firstWhere((element) =>
                                        element.id == widget.product.categoryId)
                                    .name}'),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
            child: Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    child: widget.product.getImage(
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Code: ${widget.product.barcode} Category: ${vm.store.state.categoryState.categories
                                    .firstWhere((element) =>
                                        element.id == widget.product.categoryId)
                                    .name}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}



class ProductTileViewModel {
  final Product product;

  final Store<AppState> store;

  ProductTileViewModel(this.store, {
    required this.product,
  });
}