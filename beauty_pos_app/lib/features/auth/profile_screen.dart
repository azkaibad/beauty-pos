// lib/features/auth/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_notifier.dart';
import '../../ui/desktop/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundCard,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 17),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.backgroundMuted),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ─── AVATAR SECTION ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.backgroundMuted),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(80),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
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
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user?.name ?? '-',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '-',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  // Role badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.primaryRole.toUpperCase() ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ─── INFO SECTION ───────────────────────────────────────────────
            _InfoCard(
              title: 'Informasi Akun',
              items: [
                _InfoRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Nama',
                  value: user?.name ?? '-',
                ),
                _InfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: user?.email ?? '-',
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Telepon',
                  value: user?.phone ?? '-',
                ),
                _InfoRow(
                  icon: Icons.store_outlined,
                  label: 'Cabang',
                  value: user?.branch?.name ?? 'Semua Cabang',
                ),
                _InfoRow(
                  icon: Icons.shield_outlined,
                  label: 'Role',
                  value: user?.roles.map((r) => r.name).join(', ') ?? '-',
                ),
                _InfoRow(
                  icon: Icons.circle_outlined,
                  label: 'Status',
                  value: user?.isActive == true ? 'Aktif' : 'Nonaktif',
                  valueColor: user?.isActive == true
                      ? AppColors.success
                      : AppColors.error,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ─── ACTIONS ─────────────────────────────────────────────────────
            _ActionCard(
              title: 'Keamanan',
              items: [
                _ActionTile(
                  icon: Icons.lock_outline_rounded,
                  label: 'Ganti Password',
                  onTap: () => context.push('/change-password'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ─── LOGOUT BUTTON ────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout_rounded,
                    color: AppColors.error, size: 18),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                      color: AppColors.error, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── INFO CARD ───────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoRow> items;

  const _InfoCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.backgroundMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
          ...items.map((item) => item),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 18),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ACTION CARD ─────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final String title;
  final List<_ActionTile> items;

  const _ActionCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.backgroundMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
          ...items.map((item) => item),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: AppColors.textSecondary, size: 20),
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textMuted, size: 20),
      onTap: onTap,
    );
  }
}
