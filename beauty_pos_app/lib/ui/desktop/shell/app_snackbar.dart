// lib/ui/desktop/shell/app_snackbar.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum SnackBarType { success, error, warning, info }

class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final config = _getConfig(type);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: _SnackBarContent(
            message: message,
            icon: config.$1,
            color: config.$2,
            actionLabel: actionLabel,
            onAction: onAction,
          ),
        ),
      );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, type: SnackBarType.success);

  static void error(BuildContext context, String message) =>
      show(context, message: message, type: SnackBarType.error);

  static void warning(BuildContext context, String message) =>
      show(context, message: message, type: SnackBarType.warning);

  static void info(BuildContext context, String message) =>
      show(context, message: message, type: SnackBarType.info);

  static (IconData, Color) _getConfig(SnackBarType type) {
    return switch (type) {
      SnackBarType.success => (
          Icons.check_circle_outline_rounded,
          AppColors.success
        ),
      SnackBarType.error => (
          Icons.error_outline_rounded,
          AppColors.error
        ),
      SnackBarType.warning => (
          Icons.warning_amber_rounded,
          AppColors.warning
        ),
      SnackBarType.info => (
          Icons.info_outline_rounded,
          AppColors.info
        ),
    };
  }
}

class _SnackBarContent extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SnackBarContent({
    required this.message,
    required this.icon,
    required this.color,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon lingkaran berwarna
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          // Pesan
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Action button (opsional)
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: color, fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
