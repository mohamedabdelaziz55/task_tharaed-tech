import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String prefKeyUserToken = 'USER_TOKEN';
  static const String prefKeyUserData = 'USER_DATA';

  static Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefKeyUserToken, token);
    print('Saving user token: $token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefKeyUserToken);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefKeyUserToken);
  }

  static Future<void> saveUserData({
    required String username,
    required String email,
    required String? imageUrl,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final userData = {
      'username': username,
      'email': email,
      'image': imageUrl,
      'token': token,
    };

    final jsonString = jsonEncode(userData);
    await prefs.setString(prefKeyUserData, jsonString);
    print(' User data saved locally: $jsonString');
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(prefKeyUserData);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefKeyUserData);
    await prefs.remove(prefKeyUserToken);
    print('User data cleared.');
  }
}
