// lib/features/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_notifier.dart';
import '../../core/utils/responsive.dart';
import '../../ui/desktop/theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await ref.read(authProvider.notifier).login(
            _emailCtrl.text.trim(),
            _passwordCtrl.text,
          );
      if (mounted) context.go('/dashboard');
    } catch (e) {
      setState(() {
        _errorMessage = ref.read(authProvider).errorMessage ?? 'Login gagal';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  // ─── DESKTOP LAYOUT ────────────────────────────────────────────────────────
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Panel — Branding
        Expanded(
          flex: 5,
          child: _buildBrandingPanel(),
        ),
        // Right Panel — Form
        Expanded(
          flex: 4,
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: _buildFormCard(isDesktop: true),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── MOBILE LAYOUT ─────────────────────────────────────────────────────────
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Column(
            children: [
              _buildMobileHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: _buildFormCard(isDesktop: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── BRANDING PANEL (Desktop) ───────────────────────────────────────────────
  Widget _buildBrandingPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0D14), Color(0xFF2D1525)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -60,
            left: -60,
            child: _decorCircle(300, AppColors.primary.withOpacity(0.08)),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: _decorCircle(350, AppColors.accent.withOpacity(0.06)),
          ),
          Positioned(
            top: 200,
            right: 40,
            child: _decorCircle(120, AppColors.primaryLight.withOpacity(0.05)),
          ),

          // Center content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.spa_rounded,
                        color: Colors.white, size: 38),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Beauty POS',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.primaryGradient.createShader(bounds),
                    child: const Text(
                      'Sistem POS Klinik Kecantikan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Feature list
                  ...[
                    ('💆', 'Manajemen Pasien & Antrian'),
                    ('💳', 'Kasir & Transaksi Real-time'),
                    ('📊', 'Laporan Keuangan & Omset'),
                    ('🩺', 'Rekam Medis Digital'),
                  ].map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: [
                            Text(f.$1,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 12),
                            Text(
                              f.$2,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── MOBILE HEADER ─────────────────────────────────────────────────────────
  Widget _buildMobileHeader() {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0D14), Color(0xFF2D1525)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: _decorCircle(200, AppColors.primary.withOpacity(0.1)),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.spa_rounded,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Beauty POS',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sistem POS Klinik Kecantikan',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── FORM CARD ─────────────────────────────────────────────────────────────
  Widget _buildFormCard({required bool isDesktop}) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 40 : 28),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.backgroundMuted, width: 1),
        boxShadow: isDesktop
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 48,
                  offset: const Offset(0, 16),
                ),
              ]
            : null,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              'Selamat Datang 👋',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: isDesktop ? 26 : 22,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Masuk ke akun Beauty POS Anda',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Error Banner
            if (_errorMessage != null) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Email
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'nama@beautypos.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email wajib diisi';
                if (!v.contains('@')) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password
            TextFormField(
              controller: _passwordCtrl,
              obscureText: _obscurePassword,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              onFieldSubmitted: (_) => _login(),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password wajib diisi';
                if (v.length < 6) return 'Password minimal 6 karakter';
                return null;
              },
            ),
            const SizedBox(height: 28),

            // Login Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  disabledBackgroundColor: AppColors.primaryDark.withOpacity(0.5),
                ).copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.disabled)) {
                      return AppColors.primaryDark.withOpacity(0.5);
                    }
                    return null;
                  }),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: _isLoading
                        ? null
                        : AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Footer
            Center(
              child: Text(
                '© 2026 Beauty POS — Klinik Kecantikan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
