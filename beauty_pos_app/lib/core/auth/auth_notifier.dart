// lib/core/auth/auth_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/token_storage.dart';
import '../models/user_model.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(dioProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final Dio _dio;

  AuthNotifier(this._dio) : super(const AuthState()) {
    _restoreSession();
  }

  /// Coba restore session dari token yang tersimpan
  Future<void> _restoreSession() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }

    try {
      final response = await _dio.get('/me');
      final user = UserModel.fromJson(response.data['data']);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
      );
    } catch (_) {
      await TokenStorage.clearToken();
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Login dengan email & password
  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data['data'];
      final token = data['token'] as String;
      final user = UserModel.fromJson(data['user']);

      await TokenStorage.saveToken(token);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
        errorMessage: null,
      );
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Login gagal';
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: message,
      );
      rethrow;
    }
  }

  /// Logout dan hapus token
  Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } catch (_) {
      // tetap logout walaupun API error
    } finally {
      await TokenStorage.clearToken();
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Refresh data user dari server
  Future<void> refreshUser() async {
    try {
      final response = await _dio.get('/me');
      final user = UserModel.fromJson(response.data['data']);
      state = state.copyWith(user: user);
    } catch (_) {}
  }
}
