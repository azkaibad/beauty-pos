// lib/ui/desktop/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Primary — Rose Gold / Pink
  static const Color primary = Color(0xFFD4838F);
  static const Color primaryLight = Color(0xFFE8A9B3);
  static const Color primaryDark = Color(0xFFAE5F6A);

  // Accent — Gold
  static const Color accent = Color(0xFFBFA07A);
  static const Color accentLight = Color(0xFFD4B896);

  // Background
  static const Color backgroundDark = Color(0xFF1A1218);
  static const Color backgroundCard = Color(0xFF261E22);
  static const Color backgroundMuted = Color(0xFF332A2E);

  // Surface
  static const Color surface = Color(0xFF2E2228);
  static const Color surfaceLight = Color(0xFF3D3038);

  // Text
  static const Color textPrimary = Color(0xFFF5EEF0);
  static const Color textSecondary = Color(0xFFB09AA0);
  static const Color textMuted = Color(0xFF7A6470);

  // Status
  static const Color success = Color(0xFF6DBF8A);
  static const Color error = Color(0xFFCF6679);
  static const Color warning = Color(0xFFE8B56D);
  static const Color info = Color(0xFF6DA8CF);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD4838F), Color(0xFFBFA07A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF1A1218), Color(0xFF261523)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        headlineLarge: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 15,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
        labelLarge: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.surfaceLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.backgroundMuted),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.backgroundCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
