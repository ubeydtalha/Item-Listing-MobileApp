import 'package:flutter/material.dart';
import 'package:flutter_application_3/action_base/action.base.dart';
import 'package:flutter_application_3/models/category.dart';

class FetchCategoryAction {
  @override
  String toString() {
    return 'CategoryAction { }';
  }
}
class FetchOneCategoryAction {
  final String id;

  FetchOneCategoryAction({required this.id});
  @override
  String toString() {
    return 'CategoryAction { }';
  }
}
class CategorySuccessAction {
  final List<Category> categories;
  final int isSuccess;

  CategorySuccessAction({required this.isSuccess, required this.categories});
  @override
  String toString() {
    return 'CategorySuccessAction { isSuccess: $isSuccess }';
  }
}

class CategoryFailedAction {
  final String error;

  CategoryFailedAction({required this.error});

  @override
  String toString() {
    return 'CategoryFailedAction { error: $error }';
  }
}

class CategoryLoadingAction {
  final int isLoading;

  CategoryLoadingAction({this.isLoading = 1});

  factory CategoryLoadingAction.trueLoading() =>
      CategoryLoadingAction(isLoading: 1);
  factory CategoryLoadingAction.falseLoading() =>
      CategoryLoadingAction(isLoading: 0);

  @override
  String toString() {
    return 'CategoryLoadingAction { }';
  }
}

class AddCategoryAction extends Add {
  final Category category;
  @override
  get item => category;
  AddCategoryAction(this.category);

  @override
  String toString() {
    return 'AddCategory { category: $category }';
  }
}

class UpdateCategoryAction extends Update {
  final Category category;
  @override
  get item => category;
  UpdateCategoryAction(this.category);

  @override
  String toString() {
    return 'UpdateCategory { category: $category }';
  }
}

class DeleteCategoryAction extends Delete {
  final Category category;
  @override
  get item => category;
  DeleteCategoryAction(this.category);

  @override
  String toString() {
    return 'DeleteCategory { category: $category }';
  }
}


class AddBulkCategoryAction {
  final List<Category> categories;
  get item => categories;
  AddBulkCategoryAction(this.categories);

  @override
  String toString() {
    return 'AddBulkCategory { categories: $categories }';
  }
}