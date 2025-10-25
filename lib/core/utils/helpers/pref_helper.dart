import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String prefKeyUserToken = 'USER_TOKEN';
  static const String prefKeyUserData = 'USER_DATA';

  /// ✅ حفظ التوكن
  static Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefKeyUserToken, token);
    print('Saving user token: $token');
  }

  /// ✅ استرجاع التوكن
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefKeyUserToken);
  }

  /// ✅ حذف التوكن
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefKeyUserToken);
  }

  /// ✅ حفظ بيانات المستخدم كاملة (username, email, image, token)
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(userData);
    await prefs.setString(prefKeyUserData, jsonString);
    print('✅ User data saved locally: $jsonString');
  }

  /// ✅ استرجاع بيانات المستخدم
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(prefKeyUserData);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// ✅ حذف بيانات المستخدم بالكامل (عند تسجيل الخروج)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefKeyUserData);
    await prefs.remove(prefKeyUserToken);
    print('🧹 User data cleared.');
  }
}
