// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  static const String appName = 'Beauty POS';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrlDev = 'http://localhost:8000/api/v1';
  static const String baseUrlProd = 'https://api.beautypos.com/api/v1';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'auth_user';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
