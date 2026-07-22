// lib/core/models/user_model.dart

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final int? branchId;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final bool isActive;
  final String? lastLoginAt;
  final List<RoleModel> roles;
  final List<PermissionModel> permissions;
  final BranchModel? branch;

  const UserModel({
    required this.id,
    this.branchId,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.isActive,
    this.lastLoginAt,
    required this.roles,
    required this.permissions,
    this.branch,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      branchId: json['branch_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      isActive: json['is_active'] ?? true,
      lastLoginAt: json['last_login_at'],
      roles: (json['roles'] as List<dynamic>? ?? [])
          .map((r) => RoleModel.fromJson(r))
          .toList(),
      permissions: (json['permissions'] as List<dynamic>? ?? [])
          .map((p) => PermissionModel.fromJson(p))
          .toList(),
      branch: json['branch'] != null
          ? BranchModel.fromJson(json['branch'])
          : null,
    );
  }

  bool hasRole(String roleName) =>
      roles.any((r) => r.name == roleName);

  bool hasPermission(String permissionName) =>
      permissions.any((p) => p.name == permissionName);

  String get primaryRole => roles.isNotEmpty ? roles.first.name : '-';

  @override
  List<Object?> get props => [id, email, roles, permissions];
}

class RoleModel extends Equatable {
  final int id;
  final String name;

  const RoleModel({required this.id, required this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      RoleModel(id: json['id'], name: json['name']);

  @override
  List<Object?> get props => [id, name];
}

class PermissionModel extends Equatable {
  final int id;
  final String name;

  const PermissionModel({required this.id, required this.name});

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel(id: json['id'], name: json['name']);

  @override
  List<Object?> get props => [id, name];
}

class BranchModel extends Equatable {
  final int id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final bool isActive;

  const BranchModel({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    required this.isActive,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        phone: json['phone'],
        email: json['email'],
        isActive: json['is_active'] ?? true,
      );

  @override
  List<Object?> get props => [id, name];
}
