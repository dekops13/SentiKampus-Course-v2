import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const navy = Color(0xFF1D2C5B);
  static const teal = Color(0xFF0B7A75);
  static const coral = Color(0xFFE25D4F);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: navy,
      primary: navy,
      secondary: teal,
      tertiary: coral,
      surface: const Color(0xFFF7F8FC),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF1F4F9),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}

