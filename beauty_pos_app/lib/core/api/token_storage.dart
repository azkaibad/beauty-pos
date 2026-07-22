// lib/core/api/token_storage.dart
// NOTE: Menggunakan SharedPreferences untuk development Windows.
// Ganti dengan flutter_secure_storage untuk production.

import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class TokenStorage {
  TokenStorage._();

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
