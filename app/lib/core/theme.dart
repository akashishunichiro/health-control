import 'package:flutter/material.dart';

/// Ilova ranglari va mavzusi (Material 3, "salomatlik" yashil-ko'k estetikasi).
class AppColors {
  static const seed = Color(0xFF1FA37A); // asosiy yashil
  static const water = Color(0xFF2E9BE6);
  static const food = Color(0xFFEF8E3B);
  static const sleep = Color(0xFF6C5CE7);
  static const activity = Color(0xFF18B26B);
  static const med = Color(0xFFE0556E);
  static const weight = Color(0xFF8E7CC3);
}

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.seed,
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor:
        brightness == Brightness.light ? const Color(0xFFF6F8F9) : null,
    appBarTheme: const AppBarTheme(centerTitle: false),
    cardTheme: CardThemeData(
      elevation: 0,
      color: brightness == Brightness.light ? Colors.white : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
