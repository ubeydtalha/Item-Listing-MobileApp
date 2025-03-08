import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> saveLastLoggedInUsers(List<String> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('loggedInUsers', users);
  }

  static Future<List<String>> getLastLoggedInUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('loggedInUsers') ?? [];
  }
}