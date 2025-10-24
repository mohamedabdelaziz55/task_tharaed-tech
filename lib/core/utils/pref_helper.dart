import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String prefKeyUserToken = 'USER_TOKEN';

  static Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefKeyUserToken, token);

    print('Saving user token: $token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.get(prefKeyUserToken);
    return null;
  }

  static Future<String?> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(prefKeyUserToken);
    return null;
  }
}
