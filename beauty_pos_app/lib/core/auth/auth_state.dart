// lib/core/auth/auth_state.dart

import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? token;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.token,
    this.errorMessage,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  bool hasPermission(String permission) =>
      user?.hasPermission(permission) ?? false;

  bool hasRole(String role) => user?.hasRole(role) ?? false;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? token,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, token, errorMessage];
}
