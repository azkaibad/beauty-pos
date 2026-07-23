// lib/core/models/customer_model.dart

import 'package:equatable/equatable.dart';

class CustomerModel extends Equatable {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? gender;
  final String? dateOfBirth;
  final String? address;
  final String? notes;
  final String? photo;
  final bool isActive;
  final String? createdAt;

  const CustomerModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.notes,
    this.photo,
    required this.isActive,
    this.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        gender: json['gender'],
        dateOfBirth: json['date_of_birth'],
        address: json['address'],
        notes: json['notes'],
        photo: json['photo'],
        isActive: json['is_active'] ?? true,
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'address': address,
        'notes': notes,
        'is_active': isActive,
      };

  CustomerModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? gender,
    String? dateOfBirth,
    String? address,
    String? notes,
    String? photo,
    bool? isActive,
    String? createdAt,
  }) =>
      CustomerModel(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        address: address ?? this.address,
        notes: notes ?? this.notes,
        photo: photo ?? this.photo,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get genderLabel => gender == 'female' ? 'Perempuan' : gender == 'male' ? 'Laki-laki' : '-';

  @override
  List<Object?> get props => [id, name, phone, email, isActive];
}

class PaginatedCustomers {
  final List<CustomerModel> data;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const PaginatedCustomers({
    required this.data,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  factory PaginatedCustomers.fromJson(Map<String, dynamic> json) {
    final meta = json;
    return PaginatedCustomers(
      data: (json['data'] as List<dynamic>)
          .map((c) => CustomerModel.fromJson(c))
          .toList(),
      total: meta['total'] ?? 0,
      currentPage: meta['current_page'] ?? 1,
      lastPage: meta['last_page'] ?? 1,
      perPage: meta['per_page'] ?? 15,
    );
  }

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPrevPage => currentPage > 1;
}
