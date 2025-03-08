
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/product/product.action.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> productMiddleware() {
  return [
    TypedMiddleware<AppState, FetchProductAction>(_fetchProducts).call,
  ];
}

void _fetchProducts(Store<AppState> store, FetchProductAction action, NextDispatcher dispatch) async {
  dispatch(action);
  try {

    // if (store.state.productState.isLoading == 1) return;

    // store.dispatch(ProdutsLoadingAction(isLoading: 1));

    // Burada ürünleri API veya başka bir kaynaktan getirin
    // await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    // final products = List.generate(20, (index) => Product.random());
    // store.dispatch(ProductSuccessAction(products:products,isSuccess: 1));
  } catch (error) {
    // store.dispatch(ProductFailedAction(error:error.toString()));
  }
}