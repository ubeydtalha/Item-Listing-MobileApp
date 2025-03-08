
import 'package:flutter_application_3/models/category.dart';

class CategoryState {


	final bool isLoading;
	final String error;
  final List<Category> categories;

	CategoryState(this.isLoading, this.error, this.categories );

	factory CategoryState.initial() => CategoryState(false, '' , []);

	CategoryState copyWith({bool? isLoading, String? error, List<Category>? categories}) =>
		CategoryState(isLoading ?? this.isLoading, error ?? this.error,  categories ?? this.categories);

	@override
	bool operator ==(other) =>
		identical(this, other) ||
		other is CategoryState &&
			runtimeType == other.runtimeType &&
			isLoading == other.isLoading &&
			error == other.error &&
      categories == other.categories;

	@override
	int get hashCode =>
		super.hashCode ^ runtimeType.hashCode ^ isLoading.hashCode ^ error.hashCode ^ categories.hashCode;

	@override
	String toString() => "CategoryState { isLoading: $isLoading,  error: $error , categories: $categories }";

  static CategoryState fromJson(dynamic json) {
    return CategoryState(
      json['isLoading'] as bool,
      json['error'] as String,
      (json['categories'] as List).map((e) => Category.fromJson(e)).toList(),
    );
  }

  dynamic toJson() {
    return {
      'isLoading': isLoading,
      'error': error,
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}
	  