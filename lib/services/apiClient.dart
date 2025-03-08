import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_application_3/action_base/action.base.dart';
import 'package:flutter_application_3/models/category.dart';
import 'package:flutter_application_3/models/product.dart';
import 'package:flutter_application_3/models/response.base.dart';
import 'package:flutter_application_3/models/sync.dart';
import 'package:flutter_application_3/models/team.dart';
import 'package:flutter_application_3/models/teams_user.dart';
import 'package:flutter_application_3/models/user.dart' as myUser;
import 'package:flutter_application_3/store/app.action.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/category/category.action.dart';
import 'package:flutter_application_3/store/product/product.action.dart';
import 'package:flutter_application_3/store/team/team.action.dart';
import 'package:flutter_application_3/store/team/team.state.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/src/response.dart';
import 'package:redux/redux.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiClient {
  static const String domain = '10.0.2.2:8000';
  static const String baseUrl = 'http://$domain/api';
  static const String apiVersion = 'v1';
  static const String url = '$baseUrl/$apiVersion';
  static const String products = '$url/items';
  static const String categories = '$url/category';
  static const String login = '$url/login';
  static const String register = '$url/register';
  static const String team = '$url/team';
  static const String teamUsers = '$url/teams-user';
  static String wsURL = 'ws://$domain/api/$apiVersion/sync';
  // Websocket ile haberleşilecek
  static const String sync_ws = 'ws://$domain/api/$apiVersion/sync';
  static WebSocketChannel? wsRecivedChannel;
  static StreamSubscription? wsHandler;
  static bool isInitalFetch_ = false;

  get isInitilFetch => isInitalFetch_;
  set isInitalFetch(bool value) => isInitalFetch_ = value;

  // late WebSocketChannel wsSendChannel;

  List<dynamic> stateUpdateQueue = [];

  Future<bool> wsReciveChannelChanger(AppState state) async {
    try {
      wsRecivedChannel?.sink.close();
    } catch (e) {}

    wsRecivedChannel = WebSocketChannel.connect(Uri.parse((state
                .teamState.selectedTeam!.id ==
            '00000000-0000-0000-0000-000000000000'
        ? '$sync_ws/user/${state.userAuthState.user!.id}/ws?token=${state.userAuthState.session!.accessToken}'
        : '$sync_ws/team/${state.teamState.selectedTeam!.id}/ws?token=${state.userAuthState.session!.accessToken}')));

    try {
      await wsRecivedChannel?.ready;
    } on SocketException {
        return false;
    } on WebSocketChannelException {
        return false;
    } catch (e) {
        return false;
    }
    return true;
  }

  void sendSyncQueue(
    SyncItemModel syncItemModel,
  ) async {
    try {
      // String wsAdrress = syncItemModel.item.teamId ==
      //         '00000000-0000-0000-0000-000000000000'
      //     ? '$sync_ws/user/${syncItemModel.item.userId}/ws?token=${session.accessToken}'
      //     : '$sync_ws/team/${syncItemModel.item.teamId}/ws?token=${session.accessToken}';
      // wsRecivedChannel = WebSocketChannel.connect(
      //   Uri.parse(wsAdrress),
      //   // protocols: ['json'],
      // );
      wsRecivedChannel?.sink.add(jsonEncode(syncItemModel.toJson()));
    } on WebSocketChannelException catch (e) {
      print(e);
    } finally {
      // wsRecivedChannel.sink.close();
    }
  }

  Future<void> listenWs(Store<AppState> store) async {
    if (!store.state.isOnline) return;
    try {
      wsHandler = wsRecivedChannel?.stream.listen((event) {
        SyncItemModel syncItemModel = SyncItemModel.fromJson(jsonDecode(event));
        store.dispatch(AddToSyncRecivedQueueAction(syncItemModel));
      }, onError: (e) {
        print(e);
      }, cancelOnError: true);
    } catch (e) {
      print(e);
    }
  }

  void closeListenWs() {
    wsRecivedChannel?.sink.close();
    wsHandler?.cancel();
  }

  void closeSendWs() {
    wsRecivedChannel?.sink.close();
    wsHandler?.cancel();
  }

  http.Client client = http.Client();

  final Session session;

  ApiClient(this.session);

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static const Map<String, String> headersWithToken = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer',
  };

  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.accessToken}',
    };
  }

  void startSyncronizetor(Store<AppState> store) async {}

  void syncIsolate(
    Store<AppState> store,
  ) async {
    await for (var action in store.state.syncQueueStream()) {
      try {
        // Bireysel kullanıcı için websocket ile haberleşmeye gerek yok
        if (action.item.teamId == '00000000-0000-0000-0000-000000000000') {
          switch (action.action) {
            case ActionType.ADD:
              if (action.type == 'Category') {
                Category category =
                    await createCategory(action.item as Category);
                stateUpdateQueue.add(UpdateCategoryAction(category));
              } else if (action.type == 'Product') {
                Product product = await createProduct(action.item as Product);
                stateUpdateQueue.add(UpdateProductAction(product));
              }

              break;
            case ActionType.UNKNOWN:
              break;
            case ActionType.UPDATE:
              if (action.type == 'Category') {
                bool result = await updateCategory(action.item as Category);
                if (result) {
                  stateUpdateQueue
                      .add(UpdateCategoryAction(action.item as Category));
                }
              } else if (action.type == 'Product') {
                bool result = await updateProduct(action.item as Product);
                if (result) {
                  stateUpdateQueue
                      .add(UpdateProductAction(action.item as Product));
                }
              }
              break;
            case ActionType.DELETE:
              if (action.type == 'Category') {
                bool result = await deleteCategory(action.item.id);
                if (result) {
                  stateUpdateQueue
                      .add(DeleteCategoryAction(action.item as Category));
                }
              } else if (action.type == 'Product') {
                bool result = await deleteProduct(action.item.id);
                if (result) {
                  stateUpdateQueue
                      .add(DeleteProductAction(action.item as Product));
                }
              }
              break;
          }
        } else if (action.item.teamId !=
            '00000000-0000-0000-0000-000000000000') {
          // takım için websocket ile haberleş
          sendSyncQueue(action);
        }
        stateUpdateQueue.add(RemoveItemFromSyncQueueAction(action));
      } catch (e) {
        print(e);
      }
    }
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<int> connectBackend() async {
    try {
      final response = await client.post(
        Uri.parse('$login/jwt'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${session.accessToken}',
        },
        body: jsonEncode({
          'access_token': session.accessToken,
          'refresh_token': session.refreshToken,
          'token_type': session.tokenType,
        }),
      );

      return response.statusCode;
    } catch (e) {
      // print(e);
      return 500;
    }
  }

  Future<void> getAllMyData(Store<AppState> store) async {
    try {
      List<Team> teams = await getMyTeams();
      
      store.dispatch(AddBulkTeamsAction(teams));

      if (store.state.teamState.selectedTeam?.id ==
          "00000000-0000-0000-0000-000000000000") {
        final productsResponse = await client.get(
          Uri.parse('$products/get-by-owner'),
          headers: getHeaders(),
        );

        final categoriesResponse = await client.get(
          Uri.parse('$categories/get-by-owner'),
          headers: getHeaders(),
        );

        if (productsResponse.statusCode == 200) {
          List<Product> productsList = (jsonDecode(productsResponse.body)
                  as List)
              .map((e) => Product.fromJson(e))
              .where((element) =>
                  store.state.syncQueue
                      .where((element) => element.item.id == element.item.id)
                      .isEmpty &&
                  store.state.productState.products
                      .where((element) => element.id == element.id)
                      .isEmpty)
              .toList();
          store.dispatch(AddBulkProductAction(productsList));
        }

        if (categoriesResponse.statusCode == 200) {
          List<Category> categoriesList = (jsonDecode(categoriesResponse.body)
                  as List)
              .map((e) => Category.fromJson(e))
              .where((element) =>
                  store.state.syncQueue
                      .where((element) => element.item.id == element.item.id)
                      .isEmpty &&
                  store.state.categoryState.categories
                      .where((element) => element.id == element.id)
                      .isEmpty)
              .toList();
          store.dispatch(AddBulkCategoryAction(categoriesList));
        }
      } else {
        final productsResponse = await client.get(
          Uri.parse(
              '$products/get-by-team/${store.state.teamState.selectedTeam?.id}'),
          headers: getHeaders(),
        );

        final categoriesResponse = await client.get(
          Uri.parse(
              '$categories/get-by-team/${store.state.teamState.selectedTeam?.id}'),
          headers: getHeaders(),
        );

        if (productsResponse.statusCode == 200) {
          List<Product> productsList =
              (jsonDecode(productsResponse.body) as List)
                  .map((e) => Product.fromJson(e))
                  .where((element) => store.state.syncQueue
                      .where((element) => element.item.id == element.item.id)
                      .isEmpty)
                  .toList();
          store.dispatch(AddBulkProductAction(productsList));
        }

        if (categoriesResponse.statusCode == 200) {
          List<Category> categoriesList =
              (jsonDecode(categoriesResponse.body) as List)
                  .map((e) => Category.fromJson(e))
                  .where((element) => store.state.syncQueue
                      .where((element) => element.item.id == element.item.id)
                      .isEmpty)
                  .toList();
          store.dispatch(AddBulkCategoryAction(categoriesList));
        }

        isInitalFetch = true;
      }
    } catch (e) {}
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await client.get(
        Uri.parse('$products/get-by-owner'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Product.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Product?> getProduct(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$products/get-by-id/$id'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final response = await client.get(
        Uri.parse('$products/get-by-category/$categoryId'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Product.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      Map<String, dynamic> data = product.toCreateJson();
      final response = await client.post(
        Uri.parse('$products/create'),
        headers: getHeaders(),
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Product product_ = Product.fromJson(jsonDecode(response.body));
        product_.is_synced = true;
        return product_;
      } else {
        return product;
      }
    } catch (e) {
      return product;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      final response = await client.put(
        Uri.parse('$products/update'),
        headers: getHeaders(),
        body: jsonEncode(product.toUpdateJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('$products/delete/$id'),
        headers: getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await client.get(
        Uri.parse('$categories/get-all'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Category.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Category?> getCategory(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$categories/get-by-id/$id'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return Category.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateCategory(Category category) async {
    try {
      final response = await client.put(
        Uri.parse('$categories/update'),
        headers: getHeaders(),
        body: jsonEncode(category.toUpdateJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('$categories/delete/$id'),
        headers: getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Category> createCategory(Category category) async {
    try {
      final response = await client.post(
        Uri.parse('$categories/create'),
        headers: getHeaders(),
        body: jsonEncode(category.toCreateJson()),
      );
      category = Category.fromDatabase(jsonDecode(response.body));
      category.is_synced = true;
      return category;
    } catch (e) {
      return category;
    }
  }

  Future<Team> createTeam(Team team_) async {
    try {
      final response = await client.post(
        Uri.parse('$team/create'),
        headers: getHeaders(),
        body: jsonEncode(team_.toCreateJson()),
      );

      return Team.fromJson(jsonDecode(response.body));
    } catch (e) {
      return team_;
    }
  }

  Future<bool> updateTeam(Team team_) async {
    try {
      final response = await client.put(
        Uri.parse('$team/update'),
        headers: getHeaders(),
        body: jsonEncode(team_.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTeam(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('$team/delete/$id'),
        headers: getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List> getPublicTeams() async {
    try {
      final response = await client.get(
        Uri.parse('$team/read-all-team'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Team.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Team>> getMyTeams() async {
    try {
      final response = await client.get(
        Uri.parse('$team/read-my-teams'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Team.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<MyTeamsUserResponse> getTeamsUser(String teamId) async {
    try {
      final response = await client.get(
        Uri.parse('$teamUsers/get-by-team/$teamId'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        MyTeamsUserResponse.fromJson(data);

        return MyTeamsUserResponse.fromJson(data);
      } else {
        return MyTeamsUserResponse(
          teamsUser: [],
          users: [],
          team: null
        );
      }
    } catch (e) {
      return MyTeamsUserResponse(
        teamsUser: [],
        users: [],
        team: null
      );
    }
  } 

  Future<List<TeamsUser>> getMyTeamsUser(String userId) async {
    try {
      final response = await client.get(
        Uri.parse('$teamUsers/get-by-user/$userId') ,
        headers: getHeaders(),
      );
    
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => TeamsUser.fromJson(e))
            .toList();
      } else {
        return [];
      }
    }
    catch (e) {
      return [];
    }
  }

  Future<Response> updateTeamsUser(TeamsUser teamsUser) async {
    try {
      final response = await client.put(
        Uri.parse('$teamUsers/update'),
        headers: getHeaders(),
        body: jsonEncode(teamsUser.toUpdateJson()),
      );

      return response;
    } catch (e) {
      return Response(e.toString(), 500);
    }
  }

  Future<Response> deleteTeamsUser({required String userId, required String teamId}) async {
    try {
      final response = await client.delete(
        Uri.parse('$teamUsers/delete/$teamId/$userId'),
        headers: getHeaders(),
      );

      return response;
    } catch (e) {
      return Response(e.toString(), 500);
    }
  }

  Future<bool> invite(
      {required String teamId, required String invitedUserId , required String userId}) async {

    try {
      final response = await client.post(
        Uri.parse('$teamUsers/invite?team_id=$teamId&invited_user_id=$invitedUserId&user_id=$userId'),
        headers: getHeaders(),
        body: jsonEncode({
          'team_id': teamId,
          'invited_user_id': invitedUserId,
          'user_id': userId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List> inviteUserAutoComplete( String query) async {
      final response = await client.get(
        Uri.parse('$teamUsers/invite-autocomplete?search_text=$query'),
        headers: getHeaders(),
      );
  
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => myUser.User.fromJson(e))
            .toList();
      } else {
        return [];
      }
    }

  Future<void> acceptInvite(
      {required String teamId, required String userId}) async {
    try {
      final response = await client.post(
        Uri.parse('$teamUsers/accept-invite?team_id=$teamId&user_id=$userId'),
        headers: getHeaders(),
        body: jsonEncode({
          'team_id': teamId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future<void> rejectInvite(
      {required String teamId, required String userId}) async {
    try {
      final response = await client.post(
        Uri.parse('$teamUsers/reject-invite?team_id=$teamId&user_id=$userId'),
        headers: getHeaders(),
        body: jsonEncode({
          'team_id': teamId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

}
