import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/util.dart';
import 'db.dart';

/// Telefon datchigidan kunlik qadamlarni avtomatik o'qiydi.
/// Datchik yuklanishdan beri umumiy qadamni qaytaradi, shuning uchun
/// kun boshidagi qiymat (baseline) saqlanadi va shundan ayiriladi.
class StepTracker {
  static StreamSubscription<StepCount>? _sub;
  static bool _started = false;

  static Future<bool> requestPermission() async {
    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  static Future<void> start(void Function(int steps) onSteps) async {
    if (_started) return;
    final granted = await requestPermission();
    if (!granted) return;
    _started = true;
    _sub?.cancel();
    _sub = Pedometer.stepCountStream.listen(
      (event) {
        final key = dateKey(DateTime.now());
        final baseDate = Db.settings.get('step_base_date');
        var baseVal = Db.settings.get('step_base_value') as int?;

        if (baseDate != key || baseVal == null) {
          // Yangi kun yoki birinchi o'qish — baseline qo'yiladi.
          baseVal = event.steps;
          Db.settings.put('step_base_date', key);
          Db.settings.put('step_base_value', baseVal);
        } else if (event.steps < baseVal) {
          // Qurilma o'chib-yongan (sanagich nolga tushgan).
          baseVal = event.steps;
          Db.settings.put('step_base_value', baseVal);
        }

        final today = event.steps - baseVal;
        onSteps(today < 0 ? 0 : today);
      },
      onError: (_) {
        // Emulyatorda yoki datchik yo'q qurilmada xato bo'lishi mumkin.
      },
      cancelOnError: false,
    );
  }

  static void stop() {
    _sub?.cancel();
    _sub = null;
    _started = false;
  }
}
