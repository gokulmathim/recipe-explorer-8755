import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFFF7043); // #FF7043
  static const secondary = Color(0xFF4DB6AC); // #4DB6AC
  static const accent = Color(0xFFFFD600); // #FFD600
}

// PUBLIC_INTERFACE
class AppTheme {
  /// Builds a modern light theme using brand colors.
  static ThemeData buildTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: colorScheme.onSurface,
        elevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.black87,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.secondary.withOpacity(0.15),
        selectedColor: AppColors.secondary,
        labelStyle: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
