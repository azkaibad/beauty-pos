// lib/ui/mobile/shell/mobile_shell.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_notifier.dart';
import '../../../core/constants/app_permissions.dart';
import '../../../ui/desktop/theme/app_theme.dart';

// ─── BOTTOM NAV ITEM MODEL ─────────────────────────────────────────────────
class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData iconSelected;
  final String route;
  final String? requiredPermission;

  const BottomNavItem({
    required this.label,
    required this.icon,
    required this.iconSelected,
    required this.route,
    this.requiredPermission,
  });
}

// ─── DRAWER ITEM MODEL ──────────────────────────────────────────────────────
class DrawerNavItem {
  final String label;
  final IconData icon;
  final String route;
  final String? requiredPermission;

  const DrawerNavItem({
    required this.label,
    required this.icon,
    required this.route,
    this.requiredPermission,
  });
}

// ─── BOTTOM NAV CONFIG ──────────────────────────────────────────────────────
const _bottomNavItems = [
  BottomNavItem(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    iconSelected: Icons.dashboard_rounded,
    route: '/dashboard',
  ),
  BottomNavItem(
    label: 'Kasir',
    icon: Icons.point_of_sale_outlined,
    iconSelected: Icons.point_of_sale_rounded,
    route: '/pos',
    requiredPermission: AppPermissions.managePos,
  ),
  BottomNavItem(
    label: 'Medis',
    icon: Icons.medical_information_outlined,
    iconSelected: Icons.medical_information_rounded,
    route: '/medical-records',
    requiredPermission: AppPermissions.manageMedicalRecords,
  ),
  BottomNavItem(
    label: 'Laporan',
    icon: Icons.bar_chart_outlined,
    iconSelected: Icons.bar_chart_rounded,
    route: '/reports',
    requiredPermission: AppPermissions.viewReports,
  ),
];

// ─── DRAWER NAV CONFIG ──────────────────────────────────────────────────────
const _drawerNavItems = [
  DrawerNavItem(
    label: 'Customer',
    icon: Icons.person_search_outlined,
    route: '/customers',
    requiredPermission: AppPermissions.manageCustomers,
  ),
  DrawerNavItem(
    label: 'Produk',
    icon: Icons.inventory_2_outlined,
    route: '/products',
    requiredPermission: AppPermissions.manageProducts,
  ),
  DrawerNavItem(
    label: 'Treatment',
    icon: Icons.spa_outlined,
    route: '/treatments',
    requiredPermission: AppPermissions.manageTreatments,
  ),
  DrawerNavItem(
    label: 'Karyawan',
    icon: Icons.people_outline_rounded,
    route: '/users',
    requiredPermission: AppPermissions.manageUsers,
  ),
  DrawerNavItem(
    label: 'Cabang',
    icon: Icons.store_outlined,
    route: '/branches',
    requiredPermission: AppPermissions.manageBranches,
  ),
  DrawerNavItem(
    label: 'Pengeluaran',
    icon: Icons.receipt_long_outlined,
    route: '/expenses',
    requiredPermission: AppPermissions.manageExpenses,
  ),
  DrawerNavItem(
    label: 'Follow Up',
    icon: Icons.follow_the_signs_outlined,
    route: '/followup',
    requiredPermission: AppPermissions.manageFollowup,
  ),
];

// ─── MOBILE SHELL ───────────────────────────────────────────────────────────
class MobileShell extends ConsumerWidget {
  final Widget child;
  const MobileShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final currentRoute = GoRouterState.of(context).matchedLocation;

    // Filter bottom nav berdasarkan permission
    final visibleBottomItems = _bottomNavItems.where((item) {
      if (item.requiredPermission != null) {
        return auth.hasPermission(item.requiredPermission!);
      }
      return true;
    }).toList();

    // Index aktif
    final activeIndex = visibleBottomItems.indexWhere(
      (item) => currentRoute.startsWith(item.route),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      // ─── APP BAR ──────────────────────────────────────────────────────────
      appBar: _MobileAppBar(currentRoute: currentRoute),
      // ─── DRAWER ───────────────────────────────────────────────────────────
      drawer: _MobileDrawer(),
      // ─── BODY ─────────────────────────────────────────────────────────────
      body: child,
      // ─── BOTTOM NAVIGATION BAR ────────────────────────────────────────────
      bottomNavigationBar: visibleBottomItems.isEmpty
          ? null
          : _MobileBottomNav(
              items: visibleBottomItems,
              currentIndex: activeIndex < 0 ? 0 : activeIndex,
              onTap: (index) => context.go(visibleBottomItems[index].route),
            ),
    );
  }
}

// ─── APP BAR ────────────────────────────────────────────────────────────────
class _MobileAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String currentRoute;
  const _MobileAppBar({required this.currentRoute});

  String _getTitle() {
    if (currentRoute.startsWith('/dashboard')) return 'Dashboard';
    if (currentRoute.startsWith('/pos')) return 'Kasir / POS';
    if (currentRoute.startsWith('/medical-records')) return 'Rekam Medis';
    if (currentRoute.startsWith('/reports')) return 'Laporan';
    if (currentRoute.startsWith('/users')) return 'Karyawan';
    if (currentRoute.startsWith('/branches')) return 'Cabang';
    if (currentRoute.startsWith('/expenses')) return 'Pengeluaran';
    if (currentRoute.startsWith('/followup')) return 'Follow Up';
    if (currentRoute.startsWith('/profile')) return 'Profil Saya';
    return 'Beauty POS';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return AppBar(
      backgroundColor: AppColors.backgroundCard,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.spa_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Text(
            _getTitle(),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        // Avatar / profile button
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => context.push('/profile'),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user?.name.isNotEmpty == true
                      ? user!.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.backgroundMuted),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

// ─── BOTTOM NAVIGATION BAR ──────────────────────────────────────────────────
class _MobileBottomNav extends StatelessWidget {
  final List<BottomNavItem> items;
  final int currentIndex;
  final void Function(int) onTap;

  const _MobileBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        border: Border(top: BorderSide(color: AppColors.backgroundMuted)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == currentIndex;
              return _BottomNavTile(
                item: item,
                isActive: isActive,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavTile extends StatelessWidget {
  final BottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withAlpha(20)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? item.iconSelected : item.icon,
              color: isActive ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textMuted,
                fontSize: 11,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── DRAWER ─────────────────────────────────────────────────────────────────
class _MobileDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    // Filter drawer items berdasarkan permission
    final visibleDrawerItems = _drawerNavItems.where((item) {
      if (item.requiredPermission != null) {
        return auth.hasPermission(item.requiredPermission!);
      }
      return true;
    }).toList();

    return Drawer(
      backgroundColor: AppColors.backgroundCard,
      child: SafeArea(
        child: Column(
          children: [
            // ─── DRAWER HEADER ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A0D14), Color(0xFF2D1525)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(80),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        user?.name.isNotEmpty == true
                            ? user!.name[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Role chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.primaryRole.toUpperCase() ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ─── DRAWER MENU ITEMS ──────────────────────────────────────────
            if (visibleDrawerItems.isNotEmpty) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'MENU LAINNYA',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              ...visibleDrawerItems.map((item) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 0),
                    leading: Icon(item.icon,
                        color: AppColors.textSecondary, size: 20),
                    title: Text(
                      item.label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go(item.route);
                    },
                  )),
            ],

            const Spacer(),
            const Divider(color: AppColors.backgroundMuted, height: 1),

            // ─── PROFILE & LOGOUT ───────────────────────────────────────────
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: const Icon(Icons.person_outline_rounded,
                  color: AppColors.textSecondary, size: 20),
              title: const Text(
                'Profil Saya',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/profile');
              },
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: const Icon(Icons.logout_rounded,
                  color: AppColors.error, size: 20),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.error, fontSize: 14),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
