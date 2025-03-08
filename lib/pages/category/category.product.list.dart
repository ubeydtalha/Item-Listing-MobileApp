import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/product/product.tile.preview.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/product/product.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CategoryProductList extends StatelessWidget {
  final int category ;
  const CategoryProductList({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductViewModel>(
      builder: (context, ProductViewModel viewModel) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Products"),
          ),
          body: ListView(
              children: [
                for (var product in viewModel.products.where((element) =>
                            category == 0 ||
                            element.categoryId == category))
                          Padding(
                              padding: const EdgeInsets.all(2),
                              child: ListProductPreview(product: product)),
              ],
            )
        );
      },
      converter: (store) => ProductViewModel.fromStore(store),
      );
  }
}