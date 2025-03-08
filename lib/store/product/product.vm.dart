import 'dart:io';

import 'package:flutter_application_3/models/product.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/product/product.action.dart';
import 'package:redux/redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductViewModel {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  final Store<AppState> store;

  ProductViewModel(
    this.store, {
    required this.products,
    required this.isLoading,
    this.error,
  });

  static ProductViewModel fromStore(Store<AppState> store) {
    return ProductViewModel(
      store,
      products: store.state.productState.products,
      isLoading: store.state.productState.isLoading,
      error: store.state.productState.error,
    );
  }

  Future<void> saveProduct(Product product) async {
    Product product_ = await saveDB(product);

    store.dispatch(AddProductAction(product_));
  }

  Future<Product> saveDB(Product product) async {
    Product value = await API.client.createProduct(product);

    if (value.is_synced) {
      for (var image in product.images) {
        (Supabase.instance.client.storage.from('product_image').upload(
                  '${product.userId}/$image.jpg',
                  File('${API.path}/${ImageLocation.product}/${image}.jpg'),
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
    }
    return product;
  }

  Future<void> updateProduct(Product product) async {
    if (product.id.isEmpty) {
      // Bu durum sadece ürün state var ve senkronize değilse oluşur
      Product product_ = await saveDB(product);
      store.dispatch(UpdateProductAction(product_));
      return;
    }

    API.client
        .updateProduct(product)
        .then((value) => value
            ? {
                product.is_synced = true,
                for (var image in product.images)
                  {
                    (Supabase.instance.client.storage
                            .from('product_image')
                            .upload(
                              '${product.userId}/$image.jpg',
                              File('${API.path}/${ImageLocation.product}/${image}.jpg'),
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
                            }),
                  }
              }
            : product.is_synced = false)
        .catchError((error) => product.is_synced = false);

    store.dispatch(UpdateProductAction(product));
  }

  Future<void> deleteProduct(Product product) async {
    API.client.deleteProduct(product.id).then((value) {
      if (value) {
        Supabase.instance.client.storage.from('product_image').remove(
              [for (var image_ in product.images) '${product.userId}/$image_.jpg'],
            );
        store.dispatch(DeleteProductAction(product));
      }
    });
  }
}
