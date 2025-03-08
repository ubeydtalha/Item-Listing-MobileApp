
import 'package:flutter_application_3/models/sync.dart';
import 'package:flutter_application_3/store/app.action.dart';
import 'package:flutter_application_3/store/teamsUser/teamsuser.reducer.dart';

import './team/team.reducer.dart';
import './category/category.reducer.dart';
import './product/product.reducer.dart';
import './userAuth/userAuth.reducer.dart';
import './login/login.reducer.dart';

import './app.state.dart';

AppState appReducer(AppState state, action) {
  switch (action.runtimeType) {
    case UpdateConnectivityAction:
      // if (!action.isOnline) {
      //   API.client.closeListenWs();
      // } else {
      //   API.client.wsReciveChannelChanger(state);
      // }
      return state.copyWith(isOnline: action.isOnline);

    case AddToSyncQueueAction:
      final syncQueue = List<SyncItemModel>.from(state.syncQueue);
      // aynı item varsa silinir
      syncQueue.removeWhere((element) =>
          element.item.dummy_id == action.action.item.dummy_id ||
          (element.item.id == action.action.item.id && element.item.id != "")
          
          );

      syncQueue.add(action.action);
      return state.copyWith(syncQueue: syncQueue);

    case RemoveFirstFromSyncQueueAction:
      final syncQueue = List<SyncItemModel>.from(state.syncQueue);
      syncQueue.removeAt(0);
      return state.copyWith(syncQueue: syncQueue);

    case RemoveItemFromSyncQueueAction:
      // listeden item.dummy_id is equal to action.item.dummy_id olan item silinir
      final syncQueue = List<SyncItemModel>.from(state.syncQueue);
      syncQueue.removeWhere(
          (element) => element.item.dummy_id == action.action.item.dummy_id);
      return state.copyWith(syncQueue: syncQueue);

    case AddToSyncRecivedQueueAction:
      final syncRecivedQueue = List<SyncItemModel>.from(state.syncRecivedQueue);
      syncRecivedQueue.add(action.action);

      return state.copyWith(syncRecivedQueue: syncRecivedQueue);

    case RemoveItemFromSyncRecivedQueueAction:
      // listeden item.dummy_id is equal to action.item.dummy_id olan item silinir
      final syncRecivedQueue =
          List<SyncItemModel>.from(state.syncRecivedQueue);
      syncRecivedQueue.removeWhere(
          (element) => element.item.dummy_id == action.action.item.dummy_id ||
              (element.item.id == action.action.item.id &&
                  element.item.id != "")
              
              );
      return state.copyWith(syncRecivedQueue: syncRecivedQueue);

    default:
      return state.copyWith(
        teamState: teamReducer(state.teamState, action),
        categoryState: categoryReducer(state.categoryState, action),
        productState: productReducer(state.productState, action),
        userAuthState: userAuthReducer(state.userAuthState, action),
        loginState: loginReducer(state.loginState, action),
        teamsUserState: teamsUserReducer(state.teamsUserState, action),
      );
  }
}
