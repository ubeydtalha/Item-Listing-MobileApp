
import 'package:flutter_application_3/models/category.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/category/category.action.dart';
import 'package:redux/redux.dart';
import './category.state.dart';

final categoryReducer = combineReducers<CategoryState>([
  TypedReducer<CategoryState, CategorySuccessAction>(_fetchCategoriesSuccess).call,
  TypedReducer<CategoryState, CategoryFailedAction>(_fetchCategoriesFailure).call,
  TypedReducer<CategoryState, CategoryLoadingAction>(_fetchCategoriesLoading).call,
  TypedReducer<CategoryState, AddCategoryAction>(addCategoryReducer).call,
  TypedReducer<CategoryState, UpdateCategoryAction>(updateCategoryReducer).call,
  TypedReducer<CategoryState, DeleteCategoryAction>(deleteCategoryReducer).call,
  TypedReducer<CategoryState, FetchOneCategoryAction>(fetchOneCategoryReducer).call,
  TypedReducer<CategoryState, AddBulkCategoryAction>(addBulkCategoryReducer).call,
]);
	

CategoryState fetchCategoryReducer(CategoryState state,FetchCategoryAction action) {
  return categoryReducer(state, action);
}

CategoryState _fetchCategoriesSuccess(CategoryState state, CategorySuccessAction action) {
  return state.copyWith(isLoading: false, error: null, categories: action.categories);
}

CategoryState _fetchCategoriesFailure(CategoryState state,CategoryFailedAction action) {
  return state.copyWith(isLoading: false, error: action.error);
}

CategoryState _fetchCategoriesLoading(CategoryState state,CategoryLoadingAction action) {
  return state.copyWith(isLoading: true, error: null);
}



CategoryState addCategoryReducer(CategoryState state, AddCategoryAction action) {
  final categories = List<Category>.from(state.categories);

  bool hasIt = categories.any((element) => element.dummy_id == action.category.dummy_id || element.id == action.category.id);
  if (hasIt) {
    return state;
  }
  categories.add(action.category);
  return state.copyWith(categories: categories);
}


CategoryState updateCategoryReducer(CategoryState state, UpdateCategoryAction action) {
  final categories = List<Category>.from(state.categories);
  Iterable<Category> newCategories = categories.where(
      (element) => element.dummy_id != action.category.dummy_id && element.id != action.category.id
  );

  newCategories = newCategories.followedBy([action.category]);

  return state.copyWith(categories: newCategories.toList());
}

CategoryState deleteCategoryReducer(CategoryState state, DeleteCategoryAction action) {
  final categories = List<Category>.from(state.categories);
  final newCategories = categories.where(
      (element) => element.dummy_id != action.category.dummy_id && element.id != action.category.id
  );

  return state.copyWith(categories: newCategories.toList());
}

CategoryState fetchOneCategoryReducer(CategoryState state, FetchOneCategoryAction action) {
  Category? category;
  List<Category> categories = List<Category>.from(state.categories);

  API.client.getCategory(action.id).then((value) {
    if (value == null) {
      return state;
    }
    category = value;

    categories.removeWhere((element) => element.id == action.id);
    categories.add(category!);
  });

  return state.copyWith(categories: categories);
}


CategoryState addBulkCategoryReducer(CategoryState state, AddBulkCategoryAction action) {
  final categories = List<Category>.from(state.categories);
  categories.removeWhere(
      (element) => action.categories.any((e) => e.dummy_id == element.dummy_id || e.id == element.id && element.is_synced)
  );
  
  categories.addAll(action.categories);

  return state.copyWith(categories: categories);
}