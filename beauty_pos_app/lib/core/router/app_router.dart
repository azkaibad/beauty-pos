// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_notifier.dart';
import '../../core/auth/auth_state.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/profile_screen.dart';
import '../../features/auth/change_password_screen.dart';
import '../../features/customers/screens/customer_list_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../ui/desktop/shell/desktop_shell.dart';
import '../../ui/mobile/shell/mobile_shell.dart';
import '../../core/utils/responsive.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoginPage = state.matchedLocation == '/login';

      if (authState.status == AuthStatus.initial) return null;
      if (authState.isAuthenticated && isLoginPage) return '/dashboard';
      if (!authState.isAuthenticated && !isLoginPage) return '/login';

      return null;
    },
    refreshListenable: RouterNotifier(ref),
    routes: [
      // Login — no shell
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Shell routes — wrapped in DesktopShell for desktop
      ShellRoute(
        builder: (context, state, child) {
          if (Responsive.isDesktop(context)) {
            return DesktopShell(child: child);
          }
          return MobileShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/customers',
            builder: (context, state) => const CustomerListScreen(),
          ),
          GoRoute(
            path: '/pos',
            builder: (context, state) => const _PlaceholderPage(title: 'Kasir / POS'),
          ),
          GoRoute(
            path: '/medical-records',
            builder: (context, state) => const _PlaceholderPage(title: 'Rekam Medis'),
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const _PlaceholderPage(title: 'Manajemen Karyawan'),
          ),
          GoRoute(
            path: '/branches',
            builder: (context, state) => const _PlaceholderPage(title: 'Manajemen Cabang'),
          ),
          GoRoute(
            path: '/expenses',
            builder: (context, state) => const _PlaceholderPage(title: 'Pengeluaran'),
          ),
          GoRoute(
            path: '/followup',
            builder: (context, state) => const _PlaceholderPage(title: 'Follow Up Pasien'),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const _PlaceholderPage(title: 'Laporan & Omset'),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      // Routes yang bisa di-push dari mana saja (tanpa shell)
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Halaman tidak ditemukan')),
    ),
  );
});

// Placeholder untuk halaman yang belum dibuat
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1218),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction_rounded,
                size: 64, color: Color(0xFFD4838F)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Halaman ini sedang dalam pengembangan',
              style: TextStyle(color: Color(0xFF7A6470)),
            ),
          ],
        ),
      ),
    );
  }
}

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}
