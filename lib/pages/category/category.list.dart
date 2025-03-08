import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/category/category.grid.view.dart';
import 'package:flutter_application_3/models/category.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/category/category.action.dart';
import 'package:flutter_application_3/store/category/category.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CategoryList extends StatefulWidget {


  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CategoryViewModel>(
      onInit: (store) => store.dispatch(FetchCategoryAction()),
      builder: (context, CategoryViewModel viewModel) {
        return Column(
          children: [
            SearchBar(
              hintText: 'Search category',
              onChanged: (value) {
                print(value);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
                child: GridView.count(
              scrollDirection: Axis.vertical,
              crossAxisCount: 3,
              padding: const EdgeInsets.all(10),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: viewModel.isLoading ?   [const Center(child: CircularProgressIndicator(),)]
              : [
                for (var category in viewModel.categories.where(
                    (element) => element.teamId == viewModel.store.state.teamState.selectedTeam?.id
                ))
                  CategoryPreview(category: category),
              ],
            ))
          ],
        );
      },
      converter: (store) => CategoryViewModel.fromStore(store),
    );
  }
}
