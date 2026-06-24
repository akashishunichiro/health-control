import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db.dart';

/// Ilova sozlamalari: mavzu va o'lchov birliklari.
class AppSettings {
  final ThemeMode themeMode;
  final String weightUnit; // 'kg' | 'lb'
  const AppSettings(this.themeMode, this.weightUnit);
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final tm = Db.settings.get('theme_mode') as String? ?? 'system';
    final wu = Db.settings.get('weight_unit') as String? ?? 'kg';
    return AppSettings(_parse(tm), wu);
  }

  ThemeMode _parse(String s) => s == 'light'
      ? ThemeMode.light
      : s == 'dark'
          ? ThemeMode.dark
          : ThemeMode.system;

  String _str(ThemeMode m) => m == ThemeMode.light
      ? 'light'
      : m == ThemeMode.dark
          ? 'dark'
          : 'system';

  void setTheme(ThemeMode m) {
    Db.settings.put('theme_mode', _str(m));
    state = AppSettings(m, state.weightUnit);
  }

  void setWeightUnit(String unit) {
    Db.settings.put('weight_unit', unit);
    state = AppSettings(state.themeMode, unit);
  }
}

// ---- Vazn birligi yordamchilari (ichkarida har doim kg saqlanadi) ----
double kgToDisplay(double kg, String unit) =>
    unit == 'lb' ? kg * 2.20462 : kg;

double displayToKg(double v, String unit) => unit == 'lb' ? v / 2.20462 : v;

String weightUnitLabel(String unit) => unit == 'lb' ? 'funt' : 'kg';
