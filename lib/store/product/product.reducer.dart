import 'package:flutter_application_3/models/product.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/product/product.action.dart';
import 'package:redux/redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './product.state.dart';
import 'package:logging/logging.dart';

final productReducer = combineReducers<ProductState>([
  TypedReducer<ProductState, ProductSuccessAction>(_fetchProductsSuccess).call,
  TypedReducer<ProductState, ProductFailedAction>(_fetchProductsFailure).call,
  TypedReducer<ProductState, ProdutsLoadingAction>(_fetchProductsLoading).call,
  TypedReducer<ProductState, AddProductAction>(addProductReducer).call,
  TypedReducer<ProductState, UpdateProductAction>(updateProductReducer).call,
  TypedReducer<ProductState, DeleteProductAction>(deleteProductReducer).call,
  TypedReducer<ProductState, FetchOneProductAction>(fetchOneProductReducer).call,
  TypedReducer<ProductState, AddBulkProductAction>(addBulkProductReducer).call,
      
]);

final _logger = Logger('ProductReducer');

ProductState fetchProductsReducer(ProductState state, action) {
  Supabase.instance.client
      .from('products')
      .stream(primaryKey: ["id"]).listen((event) {
    _logger.info(event);
  });

  return productReducer(state, action);
}

ProductState _fetchProductsSuccess(
    ProductState state, ProductSuccessAction action) {
  return state.copyWith(
      isLoading: false, error: null, products: action.products);
}

ProductState _fetchProductsFailure(
    ProductState state, ProductFailedAction action) {
  return state.copyWith(isLoading: false, error: action.error);
}

ProductState _fetchProductsLoading(
    ProductState state, ProdutsLoadingAction action) {
  return state.copyWith(isLoading: true, error: null);
}

ProductState fetchOneProductReducer(
    ProductState state, FetchOneProductAction action) {
  Product? product;
  List<Product> products = List<Product>.from(state.products);

  API.client.getProduct(action.id).then((value) {
    if (value == null) {
      return state;
    }
    product = value;

    products.removeWhere((element) => element.id == action.id);
    products.add(product!);
  }).onError((error, stackTrace) {
    _logger.severe(error, stackTrace);
    return state;
  });
  return state.copyWith(products: products);
}

ProductState addProductReducer(ProductState state, AddProductAction action) {
  final products = List<Product>.from(state.products);
  bool hasProduct = products.any((element) => element.dummy_id == action.product.dummy_id || element.id == action.product.id);
  
  if (!hasProduct) {
    products.add(action.product);
  }
  
  return state.copyWith(products: products);
}

ProductState updateProductReducer(
    ProductState state, UpdateProductAction action) {
  // TODO bu işlem çok masraflı olabilir , daha iyi çözüm bulunca değiştir
  final products = List<Product>.from(state.products);
  Iterable<Product> newProducts = products.where(
      // dummy_id'ler her zaman unique olacağından dolayı bu şekilde bir kontrol yapılabilir
      (element) => element.dummy_id != action.product.dummy_id);

  newProducts = newProducts.followedBy([action.product]);

  return state.copyWith(products: newProducts.toList());
}

ProductState deleteProductReducer(
    ProductState state, DeleteProductAction action) {
  final products = List<Product>.from(state.products);
  final newProducts =
      products.where((element) => element.dummy_id != action.product.dummy_id);

  return state.copyWith(products: newProducts.toList());
}


ProductState addBulkProductReducer(ProductState state, AddBulkProductAction action) {
  final products = List<Product>.from(state.products);

  products.removeWhere(
      (element) => action.products.any((element2) => element2.dummy_id == element .dummy_id || element2.id == element.id && element.is_synced)
  );

  products.addAll(action.products);

  return state.copyWith(products: products);
}