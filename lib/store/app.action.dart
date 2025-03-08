
import 'package:flutter_application_3/models/sync.dart';

class AppAction {

	@override
	String toString() {
	return 'AppAction { }';
	}
}

class AppSuccessAction {
	final int isSuccess;

	AppSuccessAction({required this.isSuccess});
	@override
	String toString() {
	return 'AppSuccessAction { isSuccess: $isSuccess }';
	}
}

class AppFailedAction {
	final String error;

	AppFailedAction({required this.error});

	@override
	String toString() {
	return 'AppFailedAction { error: $error }';
	}
}
	


class UpdateConnectivityAction {
  final bool isOnline;
  UpdateConnectivityAction(this.isOnline);
}

class CheckConnectivityAction {}


class AddToSyncQueueAction {
  final SyncItemModel action;
  AddToSyncQueueAction(this.action);
}

class RemoveFirstFromSyncQueueAction {
  final SyncItemModel action;
  RemoveFirstFromSyncQueueAction(this.action);
}

class RemoveItemFromSyncQueueAction {
  final SyncItemModel action;
  RemoveItemFromSyncQueueAction(this.action);
}

class AddToSyncRecivedQueueAction {
  final SyncItemModel action;
  AddToSyncRecivedQueueAction(this.action);
}

class RemoveFirstFromSyncRecivedQueueAction {
  final SyncItemModel action;
  RemoveFirstFromSyncRecivedQueueAction(this.action);
}

class RemoveItemFromSyncRecivedQueueAction {
  final SyncItemModel action;
  RemoveItemFromSyncRecivedQueueAction(this.action);
}


class StartSyncQueueAction {
}

class StopSyncQueueAction {
}