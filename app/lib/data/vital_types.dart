import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'models.dart';

/// Sog'liq ko'rsatkichi turi haqida ma'lumot.
class VitalTypeInfo {
  final String key;
  final String label;
  final String unit;
  final IconData icon;
  final Color color;
  final bool dual; // ikki qiymatli (qon bosimi)
  final bool isMood;
  const VitalTypeInfo(
    this.key,
    this.label,
    this.unit,
    this.icon,
    this.color, {
    this.dual = false,
    this.isMood = false,
  });
}

const List<VitalTypeInfo> kVitalTypes = [
  VitalTypeInfo('blood_pressure', 'Qon bosimi', 'mmHg', Icons.favorite,
      AppColors.med,
      dual: true),
  VitalTypeInfo('glucose', 'Qondagi qand', 'mmol/L', Icons.bloodtype,
      AppColors.food),
  VitalTypeInfo('pulse', 'Puls', 'bpm', Icons.monitor_heart, AppColors.water),
  VitalTypeInfo(
      'temperature', 'Harorat', '°C', Icons.thermostat, AppColors.activity),
  VitalTypeInfo('mood', 'Kayfiyat', '', Icons.mood, AppColors.sleep,
      isMood: true),
];

VitalTypeInfo vitalInfo(String key) =>
    kVitalTypes.firstWhere((e) => e.key == key);

const List<String> kMoodEmojis = ['😞', '🙁', '😐', '🙂', '😄'];
const List<String> kMoodLabels = [
  'Yomon',
  'Sust',
  'O\'rtacha',
  'Yaxshi',
  'Zo\'r'
];

/// Ko'rsatkich qiymatini matn ko'rinishida qaytaradi.
String vitalValueText(Vital v) {
  switch (v.type) {
    case 'blood_pressure':
      return '${v.v1.round()}/${v.v2.round()}';
    case 'mood':
      final i = v.v1.round().clamp(0, 4);
      return kMoodEmojis[i];
    case 'temperature':
    case 'glucose':
      return v.v1.toStringAsFixed(1);
    default:
      return v.v1.round().toString();
  }
}

/// Norma holati: matn + rang (null bo'lsa baholanmaydi).
(String, Color)? vitalStatus(Vital v) {
  bool ok;
  switch (v.type) {
    case 'blood_pressure':
      ok = v.v1 < 130 && v.v2 < 85;
      break;
    case 'glucose':
      ok = v.v1 >= 3.9 && v.v1 <= 7.0;
      break;
    case 'pulse':
      ok = v.v1 >= 60 && v.v1 <= 100;
      break;
    case 'temperature':
      ok = v.v1 >= 36.0 && v.v1 <= 37.2;
      break;
    default:
      return null;
  }
  return ok
      ? ('Normada', AppColors.activity)
      : ('E\'tibor bering', AppColors.med);
}
