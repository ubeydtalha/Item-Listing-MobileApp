
import 'package:flutter_application_3/services/apiClient.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class API {
  static late ApiClient client;
  static late String path;
  static late bool isOnline;
  static bool isInitilazed = false;
  

  static Future<void> initialize() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        return;
      }
      client = ApiClient(session);
      path = (await getApplicationDocumentsDirectory()).path;

      await client.connectBackend();
      isInitilazed = true;
    } catch (e) {
      isInitilazed = false;
    }
  }
}
