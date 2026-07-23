// lib/features/customers/data/customer_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/customer_model.dart';

class CustomerService {
  final Dio _dio;
  CustomerService(this._dio);

  Future<PaginatedCustomers> getCustomers({
    int page = 1,
    int perPage = 15,
    String? search,
    String? gender,
    bool? isActive,
  }) async {
    final response = await _dio.get('/customers', queryParameters: {
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
      if (gender != null) 'gender': gender,
      if (isActive != null) 'is_active': isActive ? 1 : 0,
    });
    return PaginatedCustomers.fromJson(response.data['data']);
  }

  Future<CustomerModel> getCustomer(int id) async {
    final response = await _dio.get('/customers/$id');
    return CustomerModel.fromJson(response.data['data']);
  }

  Future<CustomerModel> createCustomer(Map<String, dynamic> data) async {
    final response = await _dio.post('/customers', data: data);
    return CustomerModel.fromJson(response.data['data']);
  }

  Future<CustomerModel> updateCustomer(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('/customers/$id', data: data);
    return CustomerModel.fromJson(response.data['data']);
  }

  Future<void> deleteCustomer(int id) async {
    await _dio.delete('/customers/$id');
  }
}

final customerServiceProvider = Provider<CustomerService>(
  (ref) => CustomerService(ref.watch(dioProvider)),
);
