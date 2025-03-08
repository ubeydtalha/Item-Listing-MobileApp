import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/category.dart';
import 'package:flutter_application_3/models/product.dart';
import 'package:flutter_application_3/models/sync.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.action.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/category/category.action.dart';
import 'package:flutter_application_3/store/product/product.action.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SyncList extends StatefulWidget {
  const SyncList({super.key});

  @override
  State<SyncList> createState() => _SyncListState();
}

class _SyncListState extends State<SyncList> {
  late var recivedWsChannel;

  bool isSyncClicked = false;
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SyncListViewModel>(
      onInit: (store) async {
        isSyncClicked = false;
        try {
          if (store.state.isOnline) {
            try {
              bool isConnected_ =
                  await API.client.wsReciveChannelChanger(store.state);
                
                setState(() {
                  isConnected = isConnected_;
                });

              if (isConnected) API.client.listenWs(store);
            } catch (e) {
              isConnected = false;
            }
          }
        } catch (e) {
          print(e);
        }
      },
      onDispose: (store) {
        if (isConnected) {
          API.client.closeListenWs();
        }
      },
      converter: (store) => SyncListViewModel(
        store,
        syncQueue: store.state.syncQueue,
        isOnline: store.state.isOnline,
        syncRecivedQueue: store.state.syncRecivedQueue,
      ),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Text('Sync Queue'),
                const Spacer(),
                !isConnected
                    ? const Text(
                        'Not Connected',
                        style: TextStyle(color: Colors.red),
                      )
                    : !isSyncClicked
                        ? IconButton(
                            onPressed: () {
                              try {
                                viewModel.startSyncAllItems();
                                if (isSyncClicked) {
                                  setState(() {});
                                } else {
                                  isSyncClicked = true;
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Error: $e'),
                                ));
                              }
                            },
                            icon: const Icon(Icons.sync))
                        : IconButton(
                            onPressed: () {
                              viewModel.saveRecivedQueue();
                            },
                            icon: const Icon(Icons.save)),
              ],
            ),
          ),
          body: !isSyncClicked
              ? getWillSyncItems(viewModel)
              : getRecivedItems(viewModel),
        );
      },
    );
  }

  Widget getWillSyncItems(SyncListViewModel viewModel) {
    return ListView(children: [
      for (SyncItemModel item in viewModel.store.state.syncQueue.where(
          (element) =>
              element.item.teamId ==
              viewModel.store.state.teamState.selectedTeam?.id))
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, left: 2.0, right: 2.0, bottom: 2.0),
          child: ListTile(
            title: Text(item.item.toString()),
            subtitle: Text(item.type),
            trailing: SizedBox(
              width: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  Center(
                    child: Icon(
                      Icons.sync,
                      color: item.is_synced ? Colors.green : Colors.red,
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        viewModel.removeItemFromSyncQueue(item);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ]);
  }

  Widget getRecivedItems(SyncListViewModel viewModel) {
    return ListView(children: [
      for (SyncItemModel item in viewModel.store.state.syncRecivedQueue.where(
          (element) =>
              element.item.teamId ==
              viewModel.store.state.teamState.selectedTeam?.id))
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, left: 2.0, right: 2.0, bottom: 2.0),
          child: ListTile(
            title: Text(item.item.toString()),
            subtitle: Text(item.type),
            trailing: SizedBox(
              width: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  Center(
                    child: Icon(
                      Icons.sync,
                      color: item.is_synced ? Colors.green : Colors.red,
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        viewModel.removeItemFromSyncQueue(item);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ]);
  }
}

class SyncListViewModel extends ChangeNotifier {
  final List<SyncItemModel> syncQueue;
  final List<SyncItemModel> syncRecivedQueue;
  final bool isOnline;
  final Store<AppState> store;

  SyncListViewModel(this.store,
      {required this.syncRecivedQueue,
      required this.syncQueue,
      required this.isOnline});

  void startSyncAllItems() async {
    await for (SyncItemModel action in store.state.syncQueueStream()) {
      if (isOnline) {
        // Sync action
        // Remove action from sync queue
        API.client.sendSyncQueue(action);
      }
    }
    // API.client.closeSendWs();
  }

  void removeFirstFromSyncQueue(SyncItemModel action) {
    // Remove first action from sync queue
  }

  void removeItemFromSyncQueue(SyncItemModel action) {
    store.dispatch(RemoveItemFromSyncQueueAction(action));

    if (action.item.id == '' && store.state.productState.products.isNotEmpty) {
      store.dispatch(DeleteProductAction(
        store.state.productState.products.firstWhere((element) =>
            element.dummy_id == action.item.dummy_id ||
            (element.id == action.item.id && element.id != '')),
      ));
    }
  }

  void startSyncQueue() {
    // Start syncing
  }

  void saveRecivedQueue() {
    try {
      for (SyncItemModel item in syncRecivedQueue) {
        store.dispatch(RemoveItemFromSyncQueueAction(item));
        store.dispatch(RemoveItemFromSyncRecivedQueueAction(item));
        switch (item.description) {
          // item başarılı bir şekilde veritabanına kaydedilmiş demektir
          // bu yüzden kuyruklardan silinir ve item redux'taki versiyonu güncellenir

          case DescriptionType.SUCCESS:
            switch (item.type) {
              case 'Product':
                store.dispatch(UpdateProductAction(item.item as Product));
                break;
              case 'Category':
                store.dispatch(UpdateCategoryAction(item.item as Category));
                break;
            }
          case DescriptionType.ERROR:
            switch (item.type) {
              case 'Product':
                store.dispatch(DeleteProductAction(item.item as Product));
                break;
              case 'Category':
                store.dispatch(DeleteCategoryAction(item.item as Category));
                break;
            }

          case DescriptionType.FETCH:
            // burası API call yaparak itemın faha güncel halini alır
            // ve itemın redux'taki versiyonunu günceller
            switch (item.type) {
              case 'Product':
                store.dispatch(FetchOneProductAction(id: item.item.id));
                break;
              case 'Category':
                store.dispatch(FetchOneCategoryAction(id: item.item.id));
                break;
            }
          case DescriptionType.UNKNOWN:
          // hiçbir şey yapma
        }
      }
    } catch (e) {}
  }
}
