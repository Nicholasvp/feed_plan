import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _primary = Color(0xFF8867EA);
  static const _secondary = Color(0xFF2EDED4);
  static const _tertiary = Color(0xFFDB3D93);

  static ColorScheme _scheme(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: brightness,
      secondary: _secondary,
      tertiary: _tertiary,
    );
  }

  static ThemeData get light {
    final scheme = _scheme(Brightness.light);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(centerTitle: true, foregroundColor: scheme.onSurface),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
    );
  }

  static ThemeData get dark {
    final scheme = _scheme(Brightness.dark);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(centerTitle: true, foregroundColor: scheme.onSurface),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
    );
  }
}
