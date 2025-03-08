import 'dart:io';

import 'package:flutter_application_3/models/category.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/category/category.action.dart';
import 'package:flutter_application_3/store/category/category.state.dart';
import 'package:redux/redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryViewModel{
  final bool isLoading;
  final String error;
  final List<Category> categories;

  final Store<AppState> store;

  CategoryViewModel(this.store, {
    required this.isLoading,
    required this.error,
    required this.categories,
  });

  static CategoryViewModel fromStore(Store<AppState> store) {
    return CategoryViewModel(
      store,
      isLoading: store.state.categoryState.isLoading,
      error: store.state.categoryState.error,
      categories: store.state.categoryState.categories,
    );
  }

  Future<void> saveCategory(Category category) async {
    Category category_ = await saveDB(category);

    store.dispatch(AddCategoryAction(category_));
  }

  Future<Category> saveDB(Category category) async {
    Category value = await API.client.createCategory(category);

    if (value.is_synced && category.image.isNotEmpty) {
      (Supabase.instance.client.storage.from('category_image').upload(
        '${category.userId}/${category.image}.jpg',
        File('${API.path}/category/${category.image}.jpg'),
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
          return value;
    }
    return category;
  }

  Future<void> updateCategory(Category category) async {
    // Eğer 
    if (category.id.isEmpty) {
      Category category_ = await saveDB(category);
      store.dispatch(UpdateCategoryAction(category_));
      return;
    }

    API.client
        .updateCategory(category)
        .then((value) => value 
          ? {
            category.is_synced = true,
            Supabase.instance.client.storage
              .from('category_image')
              .update(
                '${category.userId}/${category.image}.jpg',
                File('${API.path}/categories/${category.image}.jpg'),
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: false,
                ),
              )
          } : category.is_synced = false)
        .catchError((error) => category.is_synced = false);

    store.dispatch(UpdateCategoryAction(category));
  }


  Future<void> fetchCategories() async {
    store.dispatch(CategoryLoadingAction.trueLoading());
    try {
      final categories = await API.client.getCategories();
      store.dispatch(CategorySuccessAction(categories: categories, isSuccess: 1));
    } catch (e) {
      store.dispatch(CategoryFailedAction(error: e.toString()));
    }
  }

  Future deleteCategory(Category category) async {
    API.client.deleteCategory(category.id).then((value) {
      if (value){
        Supabase.instance.client.storage.from('category_image').remove(['${category.userId}/${category.image}.jpg']);
        store.dispatch(DeleteCategoryAction(category));
      }
    });
  }


}