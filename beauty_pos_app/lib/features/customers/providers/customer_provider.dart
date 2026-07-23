// lib/features/customers/providers/customer_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/customer_model.dart';
import '../data/customer_service.dart';

// ─────────────────────────────────────────
// State untuk list customer (paginated)
// ─────────────────────────────────────────

class CustomerListState {
  final List<CustomerModel> customers;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final int lastPage;
  final int total;
  final String searchQuery;
  final String? genderFilter;

  const CustomerListState({
    this.customers = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.searchQuery = '',
    this.genderFilter,
  });

  CustomerListState copyWith({
    List<CustomerModel>? customers,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    int? lastPage,
    int? total,
    String? searchQuery,
    String? genderFilter,
    bool clearError = false,
    bool clearGender = false,
  }) =>
      CustomerListState(
        customers: customers ?? this.customers,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        error: clearError ? null : error ?? this.error,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        total: total ?? this.total,
        searchQuery: searchQuery ?? this.searchQuery,
        genderFilter: clearGender ? null : genderFilter ?? this.genderFilter,
      );

  bool get hasNextPage => currentPage < lastPage;
}

// ─────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────

class CustomerListNotifier extends StateNotifier<CustomerListState> {
  final CustomerService _service;

  CustomerListNotifier(this._service) : super(const CustomerListState()) {
    fetch();
  }

  Future<void> fetch({bool reset = true}) async {
    if (state.isLoading) return;

    final page = reset ? 1 : state.currentPage + 1;

    if (reset) {
      state = state.copyWith(isLoading: true, clearError: true);
    } else {
      if (!state.hasNextPage) return;
      state = state.copyWith(isLoadingMore: true);
    }

    try {
      final result = await _service.getCustomers(
        page: page,
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        gender: state.genderFilter,
      );

      final newList = reset
          ? result.data
          : [...state.customers, ...result.data];

      state = state.copyWith(
        customers: newList,
        isLoading: false,
        isLoadingMore: false,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        total: result.total,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query);
    await fetch();
  }

  Future<void> setGenderFilter(String? gender) async {
    if (gender == null) {
      state = state.copyWith(clearGender: true);
    } else {
      state = state.copyWith(genderFilter: gender);
    }
    await fetch();
  }

  Future<void> loadMore() => fetch(reset: false);

  void refresh() => fetch();

  Future<bool> delete(int id) async {
    try {
      await _service.deleteCustomer(id);
      state = state.copyWith(
        customers: state.customers.where((c) => c.id != id).toList(),
        total: state.total - 1,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final customerListProvider =
    StateNotifierProvider<CustomerListNotifier, CustomerListState>(
  (ref) => CustomerListNotifier(ref.watch(customerServiceProvider)),
);

// ─────────────────────────────────────────
// Provider untuk detail customer
// ─────────────────────────────────────────

final customerDetailProvider =
    FutureProvider.family<CustomerModel, int>((ref, id) async {
  final service = ref.watch(customerServiceProvider);
  return service.getCustomer(id);
});
