
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/category/category.action.dart';
import 'package:redux/redux.dart';

List <Middleware<AppState>> createStoreMiddleware() {
  return [
    TypedMiddleware<AppState, FetchCategoryAction>(_fetchCategories).call,
  ];
}

void _fetchCategories(Store<AppState> store, FetchCategoryAction action, NextDispatcher next) async {
  next(action);
  try {
    // store.dispatch(CategoryLoadingAction(isLoading: 1));
    // await Future.delayed(Duration(seconds: 2));
    // final categories = Category.randomCategoryList();
    // store.dispatch(CategorySuccessAction(categories: categories, isSuccess: 1));
  } catch (error) {
    // store.dispatch(CategoryFailedAction(error: error.toString()));
  }
}

