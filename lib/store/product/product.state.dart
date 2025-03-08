
import 'package:flutter_application_3/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ProductState {

  
  final List<Product> products;

	final bool isLoading;
	final String error;
  


	ProductState(this.isLoading, this.error, this.products);

	factory ProductState.initial() => ProductState(false, '', []);

static Future<ProductState> fetchProductsFromAPI() async {
  try {
	final response = await Supabase.instance.client.from('products').select(
    """
    id,
    name,
    description,
    price,
    image_url
    """,
  );
	final List<Product> products = response as List<Product>;
	return ProductState(false, '', products);
  } catch (e) {
	return ProductState(false, e.toString(), []);
  }
}

	ProductState copyWith({bool? isLoading, String? error , List<Product>? products}) =>
		ProductState(isLoading ?? this.isLoading, error ?? this.error, products ?? this.products);
	@override
	bool operator ==(other) =>
		identical(this, other) ||
		other is ProductState &&
			runtimeType == other.runtimeType &&
			isLoading == other.isLoading &&
			error == other.error &&
      products == other.products;

	@override
	int get hashCode =>
		super.hashCode ^ runtimeType.hashCode ^ isLoading.hashCode ^ error.hashCode ^ products.hashCode;

	@override
	String toString() => "ProductState { isLoading: $isLoading,  error: $error, products: $products }";

  static ProductState fromJson(dynamic json) {
    return ProductState(
      json['isLoading'] as bool,
      json['error'] as String,
      (json['products'] as List).map((e) => Product.fromJson(e)).toList(),
    );
  }

  dynamic toJson() {
    return {
      'isLoading': isLoading,
      'error': error,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}
	  