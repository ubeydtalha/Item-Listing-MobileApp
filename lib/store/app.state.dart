import './teamsUser/teamsUser.state.dart';
import 'package:flutter_application_3/models/sync.dart';

import './team/team.state.dart';
import './category/category.state.dart';
import './product/product.state.dart';
import './userAuth/userAuth.state.dart';
import './login/login.state.dart';


class AppState {
  final TeamsUserState teamsUserState;
  final TeamState teamState;
  final CategoryState categoryState;
  final ProductState productState;
  final UserAuthState userAuthState;
  final LoginState loginState;
  final bool isOnline;
  final List<SyncItemModel> syncQueue;
  final List<SyncItemModel> syncRecivedQueue ;


  AppState({ required this.teamsUserState,required this.teamState,
      required this.categoryState,
      required this.productState,
      required this.userAuthState,
      required this.loginState,
      this.isOnline = false,
      this.syncQueue = const [],
      this.syncRecivedQueue = const []});

  factory AppState.initial() => AppState(teamsUserState: TeamsUserState.initial(),
        teamState: TeamState.initial(),
        userAuthState: UserAuthState.initial(),
        categoryState: CategoryState.initial(),
        productState: ProductState.initial(),
        loginState: LoginState.initial(),
        isOnline: false,
        syncQueue: [],
        syncRecivedQueue: [],
      );

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType && teamsUserState == other.teamsUserState  &&
          teamState == other.teamState &&
          categoryState == other.categoryState &&
          productState == other.productState &&
          userAuthState == other.userAuthState &&
          loginState == other.loginState &&
          isOnline == other.isOnline &&
          syncQueue == other.syncQueue &&
          syncRecivedQueue == other.syncRecivedQueue;

  @override
  int get hashCode =>
      super.hashCode ^ teamsUserState.hashCode  ^
      teamState.hashCode ^
      categoryState.hashCode ^
      productState.hashCode ^
      userAuthState.hashCode ^
      loginState.hashCode ^
      isOnline.hashCode ^
      syncQueue.hashCode ^
      syncRecivedQueue.hashCode;

  @override
  String toString() {
    return "AppState { teamsUserState: $teamsUserState teamState: $teamState categoryState: $categoryState productState: $productState userAuthState: $userAuthState loginState: $loginState isOnline: $isOnline }";
  }

  static AppState fromJson(dynamic json) {
    // List<SyncItemModel> syncQueue_ = [];
    // try {
    //   syncQueue_ = json['syncQueue']
    //       .map((e) => {
    //             SyncItemModel(
    //                 action: switch (e['action']) {
    //                   'ADD' => ActionType.ADD,
    //                   'UPDATE' => ActionType.UPDATE,
    //                   'DELETE' => ActionType.DELETE,
    //                   _ => ActionType.UNKNOWN
    //                 },
    //                 item: e['type'] == 'category'
    //                     ? Category.fromJson(e['item'])
    //                     : Product.fromJson(e['item']),
    //                 type: e['type'])
    //           })
    //       .toList();
    // } on Exception catch (e) {
    //   syncQueue_ = [];
    // }

    return json != null
        ? AppState(
            teamsUserState: TeamsUserState.fromJson(json['teamsUserState']),
            teamState: TeamState.fromJson(json['teamState']),
            categoryState: CategoryState.fromJson(json['categoryState']),
            productState: ProductState.fromJson(json['productState']),
            userAuthState: UserAuthState.fromJson(json['userAuthState']),
            loginState: LoginState.fromJson(json['loginState']),
            syncQueue: json['syncQueue'].map((e) => SyncItemModel.fromJson(e)).toList().cast<SyncItemModel>(),
            syncRecivedQueue: json['syncRecivedQueue'].map((e) => SyncItemModel.fromJson(e)).toList().cast<SyncItemModel>(),

          )
        : AppState.initial();
  }

  dynamic toJson() {
    // List<dynamic> syncQueue = this
    //     .syncQueue
    //     .map((e) => {
    //           'action': e.action.toString(),
    //           'item': e.item.toJson(),
    //           'type': e.item.runtimeType.toString()
    //         })
    //     .toList();

    return {
      'teamState': teamState.toJson(),
      'categoryState': categoryState.toJson(),
      'productState': productState.toJson(),
      'userAuthState': userAuthState.toJson(),
      'loginState': loginState.toJson(),
      'syncQueue': syncQueue,
      'syncRecivedQueue': syncRecivedQueue,
    };
  }

  AppState copyWith(
      {
      TeamsUserState? teamsUserState,
      TeamState? teamState,
      CategoryState? categoryState,
      ProductState? productState,
      UserAuthState? userAuthState,
      LoginState? loginState,
      bool? isOnline,
      List<SyncItemModel>? syncQueue,
      List<SyncItemModel>? syncRecivedQueue,
      }) {
    return AppState(
        teamsUserState: teamsUserState ?? this.teamsUserState,
        teamState: teamState ?? this.teamState,
        categoryState: categoryState ?? this.categoryState,
        productState: productState ?? this.productState,
        userAuthState: userAuthState ?? this.userAuthState,
        loginState: loginState ?? this.loginState,
        isOnline: isOnline ?? this.isOnline,
        syncQueue: syncQueue ?? this.syncQueue,
        syncRecivedQueue: syncRecivedQueue ?? this.syncRecivedQueue,
        );
  }

  Stream<dynamic> syncQueueStream() async* {
    for (var action in syncQueue) {
      yield action;
    }
  }

  Stream<dynamic> syncRecivedQueueStream() async* {
    for (var action in syncRecivedQueue) {
      yield action;
    }
  }
}
