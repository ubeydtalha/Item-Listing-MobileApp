import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/product/product.tile.preview.dart';
import 'package:flutter_application_3/models/category.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/product/product.action.dart';
import 'package:flutter_application_3/store/product/product.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';


class ProductsList extends StatefulWidget {

  const ProductsList(
      {super.key,});

  @override
  State<ProductsList> createState() => _ProductsState();
}

class _ProductsState extends State<ProductsList>
    with TickerProviderStateMixin {
  late TabController tabController;

  String? search = "";

  int selectedCategory = 0;



  @override
  Widget build(BuildContext context) {
    // Store store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, ProductViewModel>(
      onInit: (store) {

        if (store.state.productState.products.isEmpty) {
          store.dispatch(FetchProductAction());

        }
        tabController = TabController(length: store.state.categoryState.categories.where(
            (element) => element.teamId == store.state.teamState.selectedTeam?.id
        ).length + 1, vsync: this);
        print(
          store.state.teamState.selectedTeam?.id
        );

        tabController.addListener(() {
          setState(() {
            selectedCategory = tabController.index;
          });
        });


      },
      builder: (context, ProductViewModel viewModel) {
        if (tabController.length != viewModel.store.state.categoryState.categories.where(
            (element) => element.teamId == viewModel.store.state.teamState.selectedTeam?.id
        ).length + 1) {
          tabController.dispose();
          tabController = TabController(length: viewModel.store.state.categoryState.categories.where(
              (element) => element.teamId == viewModel.store.state.teamState.selectedTeam?.id
          ).length + 1, vsync: this);
          tabController.addListener(() {
            setState(() {
              selectedCategory = tabController.index;
            });
          });
        }

        List<Category> categories = viewModel.store.state.categoryState.categories.where(
            (element) => element.teamId == viewModel.store.state.teamState.selectedTeam?.id
        ).toList();

        categories.sort((a, b) => a.order.compareTo(b.order));

        List<Widget> tabs_ = [
                    const Tab(
                      text: "All",
                    )
                  ] +
                  [
                    for (var category in categories)
                      Tab(text: category.name),
                  ];
                  


        return Column(
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              controller: tabController,
              tabs: tabs_,
              onTap: (index) {
                setState(() {
                  selectedCategory = index;
                });
              },
              
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                hintText: 'Search product',
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  for (var categoryOrder in [
                    0,
                    ...categories
                  ])
                    viewModel.isLoading ?const Center(
                      child: CircularProgressIndicator(),
                    ) :
                        ListView(
                          children: selectedCategory != 0 ? [
                            for (var product in viewModel.products.where((element) =>
                                element.teamId == viewModel.store.state.teamState.selectedTeam?.id &&
                                categories[selectedCategory - 1].id == element.categoryId && (
                                  element.name.toLowerCase().contains(search!.toLowerCase())  ||
                                  element.description.toLowerCase().contains(search!.toLowerCase()) ||
                                  element.barcode.toLowerCase().contains(search!.toLowerCase()) ||
                                  element.secondName.toLowerCase().contains(search!.toLowerCase()) 
                                  
                                  )
                                ))
                              Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: ListProductPreview(product: product)),
                          ] : [
                            for (var product in viewModel.products.where((element) =>
                                element.teamId == viewModel.store.state.teamState.selectedTeam?.id
                                && (
                                  element.name.toLowerCase().contains(search!.toLowerCase())  ||
                                  element.description.toLowerCase().contains(search!.toLowerCase()) ||
                                  element.barcode.toLowerCase().contains(search!.toLowerCase()) ||
                                  element.secondName.toLowerCase().contains(search!.toLowerCase()) 
                                  
                                  )
                                
                                ))
                              Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: ListProductPreview(product: product)),
                          ],
                        ),
                ],
              ),
            ),
          ],
        );
      },
      converter: (store) => ProductViewModel.fromStore(store),
    );
  }

  // ListView buildProducts({
  //   category = 0, // 0: All,
  // }) {
  //   return ListView(
  //     children: [
  //       for (var product in widget.products
  //           .where((element) => category == 0 || element.category == category))
  //         Padding(
  //             padding: const EdgeInsets.all(2),
  //             child: ListProductPreview(product: product)),
  //     ],
  //   );
  // }
}

