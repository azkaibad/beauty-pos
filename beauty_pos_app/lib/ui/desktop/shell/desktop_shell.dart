// lib/ui/desktop/shell/desktop_shell.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_notifier.dart';
import '../../../core/constants/app_permissions.dart';
import '../theme/app_theme.dart';

// ─── NAV ITEM MODEL ────────────────────────────────────────────────────────
class NavItem {
  final String label;
  final IconData icon;
  final IconData iconSelected;
  final String route;
  final String? requiredPermission;
  final String? requiredRole;

  const NavItem({
    required this.label,
    required this.icon,
    required this.iconSelected,
    required this.route,
    this.requiredPermission,
    this.requiredRole,
  });
}

// ─── ALL NAV ITEMS ──────────────────────────────────────────────────────────
const _allNavItems = [
  NavItem(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    iconSelected: Icons.dashboard_rounded,
    route: '/dashboard',
  ),
  NavItem(
    label: 'Customer',
    icon: Icons.person_search_outlined,
    iconSelected: Icons.person_search_rounded,
    route: '/customers',
    requiredPermission: AppPermissions.manageCustomers,
  ),
  NavItem(
    label: 'Kasir / POS',
    icon: Icons.point_of_sale_outlined,
    iconSelected: Icons.point_of_sale_rounded,
    route: '/pos',
    requiredPermission: AppPermissions.managePos,
  ),
  NavItem(
    label: 'Rekam Medis',
    icon: Icons.medical_information_outlined,
    iconSelected: Icons.medical_information_rounded,
    route: '/medical-records',
    requiredPermission: AppPermissions.manageMedicalRecords,
  ),
  NavItem(
    label: 'Karyawan',
    icon: Icons.people_outline_rounded,
    iconSelected: Icons.people_rounded,
    route: '/users',
    requiredPermission: AppPermissions.manageUsers,
  ),
  NavItem(
    label: 'Cabang',
    icon: Icons.store_outlined,
    iconSelected: Icons.store_rounded,
    route: '/branches',
    requiredPermission: AppPermissions.manageBranches,
  ),
  NavItem(
    label: 'Pengeluaran',
    icon: Icons.receipt_long_outlined,
    iconSelected: Icons.receipt_long_rounded,
    route: '/expenses',
    requiredPermission: AppPermissions.manageExpenses,
  ),
  NavItem(
    label: 'Follow Up',
    icon: Icons.follow_the_signs_outlined,
    iconSelected: Icons.follow_the_signs_rounded,
    route: '/followup',
    requiredPermission: AppPermissions.manageFollowup,
  ),
  NavItem(
    label: 'Laporan',
    icon: Icons.bar_chart_outlined,
    iconSelected: Icons.bar_chart_rounded,
    route: '/reports',
    requiredPermission: AppPermissions.viewReports,
  ),
];

// ─── SIDEBAR STATE ──────────────────────────────────────────────────────────
final sidebarExpandedProvider = StateProvider<bool>((ref) => true);

// ─── DESKTOP SHELL ──────────────────────────────────────────────────────────
class DesktopShell extends ConsumerWidget {
  final Widget child;
  const DesktopShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(sidebarExpandedProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: isExpanded ? 240 : 72,
            child: _Sidebar(isExpanded: isExpanded),
          ),
          // Divider
          Container(width: 1, color: AppColors.backgroundMuted),
          // Main content
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ─── SIDEBAR ────────────────────────────────────────────────────────────────
class _Sidebar extends ConsumerWidget {
  final bool isExpanded;
  const _Sidebar({required this.isExpanded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final currentRoute = GoRouterState.of(context).matchedLocation;

    // Filter menu berdasarkan permission/role user
    final visibleItems = _allNavItems.where((item) {
      if (item.requiredPermission != null) {
        return auth.hasPermission(item.requiredPermission!);
      }
      if (item.requiredRole != null) {
        return auth.hasRole(item.requiredRole!);
      }
      return true; // Dashboard visible to all
    }).toList();

    return Container(
      color: AppColors.backgroundCard,
      child: Column(
        children: [
          // ─── HEADER ───────────────────────────────────────────────
          _SidebarHeader(isExpanded: isExpanded),

          // ─── NAV ITEMS ────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: visibleItems.length,
              itemBuilder: (context, index) {
                final item = visibleItems[index];
                final isActive = currentRoute.startsWith(item.route);
                return _NavTile(
                  item: item,
                  isActive: isActive,
                  isExpanded: isExpanded,
                  onTap: () => context.go(item.route),
                );
              },
            ),
          ),

          // ─── FOOTER: USER INFO + LOGOUT ───────────────────────────
          const Divider(color: AppColors.backgroundMuted, height: 1),
          _SidebarFooter(isExpanded: isExpanded, user: user),
        ],
      ),
    );
  }
}

// ─── SIDEBAR HEADER ─────────────────────────────────────────────────────────
class _SidebarHeader extends ConsumerWidget {
  final bool isExpanded;
  const _SidebarHeader({required this.isExpanded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.backgroundMuted)),
      ),
      child: isExpanded
          // ── EXPANDED: Logo + Title + Collapse Button ────────────────────
          ? Row(
              children: [
                const SizedBox(width: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.spa_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Beauty POS',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded,
                      color: AppColors.textMuted, size: 22),
                  onPressed: () => ref
                      .read(sidebarExpandedProvider.notifier)
                      .state = false,
                  tooltip: 'Collapse',
                ),
              ],
            )
          // ── COLLAPSED: hanya icon logo + toggle ─────────────────────────
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.spa_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: () => ref
                      .read(sidebarExpandedProvider.notifier)
                      .state = true,
                  child: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textMuted, size: 18),
                ),
              ],
            ),
    );
  }

}

// ─── NAV TILE ───────────────────────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: isExpanded ? 14 : 16,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isActive
                  ? AppColors.primary.withAlpha(25)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? item.iconSelected : item.icon,
                  color: isActive ? AppColors.primary : AppColors.textMuted,
                  size: 22,
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isActive)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SIDEBAR FOOTER ─────────────────────────────────────────────────────────
class _SidebarFooter extends ConsumerWidget {
  final bool isExpanded;
  final dynamic user;

  const _SidebarFooter({required this.isExpanded, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Avatar widget reusable
    final avatar = Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );

    // Logout icon widget reusable
    final logoutTile = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          await ref.read(authProvider.notifier).logout();
          if (context.mounted) context.go('/login');
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isExpanded ? 12 : 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.error.withAlpha(20),
          ),
          child: Row(
            mainAxisAlignment: isExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
              if (isExpanded) ...[
                const SizedBox(width: 10),
                const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (!isExpanded) {
      // ── COLLAPSED: hanya avatar + logout icon terpusat ──────────────────
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          children: [
            avatar,
            const SizedBox(height: 8),
            logoutTile,
          ],
        ),
      );
    }

    // ── EXPANDED: avatar + nama + role + logout ──────────────────────────
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              avatar,
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'User',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user?.primaryRole ?? '-',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          logoutTile,
        ],
      ),
    );
  }
}
