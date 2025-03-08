

import 'package:flutter_application_3/action_base/action.base.dart';
import 'package:flutter_application_3/models/sync.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.action.dart';
import 'package:redux/redux.dart';
import './app.state.dart';





void connectivityMiddleware(Store<AppState> store, action, NextDispatcher next) {
  if (action is ActionBase && store.state.isOnline == false) {
    // ActionBase den türetilmiş tüm actionlar senkronize kuyruğuna eklenir internet yoksa
    store.dispatch(AddToSyncQueueAction(
        SyncItemModel(
          action: action.type,
          item: action.item,
          type: action.item.runtimeType.toString())));}   
  if  (action is StartSyncQueueAction) {
      API.client.startSyncronizetor(store);
  }
  next(action);
}