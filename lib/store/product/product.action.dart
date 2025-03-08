import 'package:flutter/material.dart';
import 'package:flutter_application_3/action_base/action.base.dart';
import 'package:flutter_application_3/models/product.dart';

class FetchProductAction {
  @override
  String toString() {
    return 'ProductAction { }';
  }
}

class FetchOneProductAction {
  final String id;

  FetchOneProductAction({required this.id});
  @override
  String toString() {
    return 'ProductAction { }';
  }
}

class ProductSuccessAction {
  final List<Product> products;
  final int isSuccess;

  ProductSuccessAction({required this.products, required this.isSuccess});
  @override
  String toString() {
    return 'ProductSuccessAction { isSuccess: $isSuccess }';
  }
}

class ProductFailedAction {
  final String error;

  ProductFailedAction({required this.error});

  @override
  String toString() {
    return 'ProductFailedAction { error: $error }';
  }
}

class ProdutsLoadingAction {
  final int isLoading;

  ProdutsLoadingAction({this.isLoading = 1});

  factory ProdutsLoadingAction.trueLoading() =>
      ProdutsLoadingAction(isLoading: 1);
  factory ProdutsLoadingAction.falseLoading() =>
      ProdutsLoadingAction(isLoading: 0);

  @override
  String toString() {
    return 'ProdutsLoadingAction { }';
  }
}

class AddProductAction extends Add {
  final Product product;
  @override
  get item => product;
  AddProductAction(this.product);

  @override
  String toString() {
    return 'AddProductAction { product: $product }';
  }
}

class UpdateProductAction extends Update {
  final Product product;
  @override
  get item => product;
  UpdateProductAction(this.product);

  @override
  String toString() {
    return 'UpdateProductAction { product: $product }';
  }
}

class DeleteProductAction extends Delete {
  final Product product;
  @override
  get item => product;
  DeleteProductAction(this.product);

  @override
  String toString() {
    return 'DeleteProductAction { product: $product }';
  }
}


class AddBulkProductAction {
  final List<Product> products;
  get items => products;
  AddBulkProductAction(this.products);

  @override
  String toString() {
    return 'AddBulkProductAction { products: $products }';
  }
}