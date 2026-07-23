// lib/features/customers/screens/customer_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/customer_model.dart';
import '../../../core/utils/responsive.dart';
import '../providers/customer_provider.dart';
import '../widgets/customer_card.dart';
import '../widgets/customer_filter_bar.dart';
import 'customer_form_screen.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(customerListProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String query) {
    ref.read(customerListProvider.notifier).search(query);
  }

  Future<void> _openForm({CustomerModel? customer}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomerFormScreen(customer: customer),
    );
    if (result == true) {
      ref.read(customerListProvider.notifier).refresh();
    }
  }

  Future<void> _confirmDelete(CustomerModel customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A1F26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Customer?',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        content: Text(
          'Customer "${customer.name}" akan dihapus. Tindakan ini tidak bisa dibatalkan.',
          style: const TextStyle(color: Color(0xFFB0A0A8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF7A6470))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE57373),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final ok = await ref.read(customerListProvider.notifier).delete(customer.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ok
              ? 'Customer "${customer.name}" berhasil dihapus'
              : 'Gagal menghapus customer'),
          backgroundColor: ok ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customerListProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1218),
      body: Column(
        children: [
          // ── Header ─────────────────────────────────────────────
          _buildHeader(isDesktop, state.total),

          // ── Filter Bar ─────────────────────────────────────────
          CustomerFilterBar(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            selectedGender: ref.watch(customerListProvider).genderFilter,
            onGenderChanged: (g) =>
                ref.read(customerListProvider.notifier).setGenderFilter(g),
          ),

          // ── Content ────────────────────────────────────────────
          Expanded(
            child: state.isLoading
                ? const _LoadingGrid()
                : state.error != null
                    ? _ErrorView(
                        error: state.error!,
                        onRetry: () =>
                            ref.read(customerListProvider.notifier).refresh(),
                      )
                    : state.customers.isEmpty
                        ? _EmptyView(onAdd: () => _openForm())
                        : _buildList(state, isDesktop),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: const Color(0xFFD4838F),
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: const Text('Tambah Customer',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop, int total) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 32 : 20,
        isDesktop ? 28 : 20,
        isDesktop ? 32 : 20,
        12,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$total customer terdaftar',
                style: const TextStyle(
                  color: Color(0xFF7A6470),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Tombol refresh
          IconButton(
            onPressed: () =>
                ref.read(customerListProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF7A6470)),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildList(CustomerListState state, bool isDesktop) {
    return RefreshIndicator(
      onRefresh: () async =>
          ref.read(customerListProvider.notifier).refresh(),
      color: const Color(0xFFD4838F),
      backgroundColor: const Color(0xFF2A1F26),
      child: isDesktop
          ? _buildDesktopTable(state)
          : _buildMobileList(state),
    );
  }

  // ── Desktop: Tabel ──────────────────────────────────────────────
  Widget _buildDesktopTable(CustomerListState state) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 100),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF221820),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF3D2D35)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.5),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(1),
                  4: FixedColumnWidth(120),
                },
                children: [
                  // Header
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFF2E2029)),
                    children: [
                      _th('Nama'),
                      _th('Email / Telepon'),
                      _th('Jenis Kelamin'),
                      _th('Status'),
                      _th('Aksi'),
                    ],
                  ),
                  // Rows
                  ...state.customers.map((c) => _buildTableRow(c)),
                ],
              ),
            ),
          ),
          // Load more indicator
          if (state.isLoadingMore)
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: Color(0xFFD4838F)),
            ),
          if (!state.hasNextPage && state.customers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Menampilkan semua ${state.total} customer',
                style: const TextStyle(color: Color(0xFF7A6470), fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(CustomerModel c) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(top: BorderSide(color: const Color(0xFF3D2D35))),
      ),
      children: [
        // Avatar + Nama
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _avatar(c),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis),
                    if (c.address != null)
                      Text(c.address!,
                          style: const TextStyle(
                            color: Color(0xFF7A6470),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Email / Phone
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (c.email != null)
                Text(c.email!,
                    style: const TextStyle(color: Color(0xFFB0A0A8), fontSize: 13),
                    overflow: TextOverflow.ellipsis),
              if (c.phone != null)
                Text(c.phone!,
                    style: const TextStyle(color: Color(0xFF7A6470), fontSize: 12)),
            ],
          ),
        ),
        // Gender
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            c.genderLabel,
            style: const TextStyle(color: Color(0xFFB0A0A8), fontSize: 13),
          ),
        ),
        // Status
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: c.isActive
                  ? const Color(0xFF1B3A2D)
                  : const Color(0xFF3A1B1B),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              c.isActive ? 'Aktif' : 'Nonaktif',
              style: TextStyle(
                color: c.isActive
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFE57373),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        // Aksi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionBtn(
                icon: Icons.edit_rounded,
                color: const Color(0xFF4FC3F7),
                tooltip: 'Edit',
                onTap: () => _openForm(customer: c),
              ),
              const SizedBox(width: 4),
              _actionBtn(
                icon: Icons.delete_outline_rounded,
                color: const Color(0xFFE57373),
                tooltip: 'Hapus',
                onTap: () => _confirmDelete(c),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _th(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF7A6470),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) =>
      Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
        ),
      );

  // ── Mobile: Kartu ───────────────────────────────────────────────
  Widget _buildMobileList(CustomerListState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: state.customers.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= state.customers.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: Color(0xFFD4838F)),
            ),
          );
        }
        final customer = state.customers[i];
        return CustomerCard(
          customer: customer,
          onEdit: () => _openForm(customer: customer),
          onDelete: () => _confirmDelete(customer),
        );
      },
    );
  }

  Widget _avatar(CustomerModel c) => CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFF5C2D3A),
        backgroundImage: c.photo != null ? NetworkImage(c.photo!) : null,
        child: c.photo == null
            ? Text(c.initials,
                style: const TextStyle(
                    color: Color(0xFFD4838F),
                    fontWeight: FontWeight.w700,
                    fontSize: 13))
            : null,
      );
}

// ── Loading shimmer ──────────────────────────────────────────────
class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF221820),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF3D2D35),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 14,
                    width: 140,
                    decoration: BoxDecoration(
                        color: const Color(0xFF3D2D35),
                        borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 8),
                Container(
                    height: 11,
                    width: 100,
                    decoration: BoxDecoration(
                        color: const Color(0xFF2E2029),
                        borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────
class _EmptyView extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyView({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF221820),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_outline_rounded,
                size: 52, color: Color(0xFF7A6470)),
          ),
          const SizedBox(height: 20),
          const Text('Belum ada customer',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Tambahkan customer pertama kamu',
              style: TextStyle(color: Color(0xFF7A6470))),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4838F),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.person_add_rounded, color: Colors.white),
            label: const Text('Tambah Customer',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ── Error State ───────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 52, color: Color(0xFFE57373)),
          const SizedBox(height: 16),
          const Text('Gagal memuat data',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(error,
              style: const TextStyle(color: Color(0xFF7A6470)),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4838F),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            label: const Text('Coba Lagi',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
