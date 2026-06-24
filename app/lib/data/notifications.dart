import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Lokal (mahalliy) bildirishnomalar xizmati — dori, suv eslatmalari.
class Notifications {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Tashkent'));
    } catch (_) {
      // standart UTC qoladi
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings: settings);
    _ready = true;
  }

  static Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'health_reminders',
      'Eslatmalar',
      channelDescription: 'Dori, suv va salomatlik eslatmalari',
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  static tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Har kuni belgilangan vaqtda takrorlanadigan eslatma.
  static Future<void> scheduleDaily(
      int id, String title, String body, int hour, int minute) async {
    if (!_ready) return;
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstance(hour, minute),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancel(int id) => _plugin.cancel(id: id);

  static Future<void> showNow(String title, String body) async {
    if (!_ready) return;
    await _plugin.show(
        id: 7777, title: title, body: body, notificationDetails: _details);
  }

  // ---- Dori eslatmalari ----
  static int _medBase(String medId) => medId.hashCode & 0x0fffffff;

  static Future<void> scheduleMedication(
      String medId, String name, List<String> times) async {
    final base = _medBase(medId);
    for (var i = 0; i < times.length; i++) {
      final parts = times[i].split(':');
      final h = int.tryParse(parts[0]) ?? 8;
      final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
      await scheduleDaily(
        base + i,
        'Dori vaqti 💊',
        '$name ni qabul qiling (${times[i]})',
        h,
        m,
      );
    }
  }

  static Future<void> cancelMedication(String medId) async {
    final base = _medBase(medId);
    for (var i = 0; i < 12; i++) {
      await cancel(base + i);
    }
  }

  // ---- Suv eslatmalari ----
  static const List<int> _waterIds = [9001, 9002, 9003, 9004, 9005];
  static const List<int> _waterHours = [9, 12, 15, 18, 21];

  static Future<void> scheduleWaterReminders(bool on) async {
    for (final id in _waterIds) {
      await cancel(id);
    }
    if (!on) return;
    for (var i = 0; i < _waterIds.length; i++) {
      await scheduleDaily(
        _waterIds[i],
        'Suv ichish vaqti 💧',
        'Bir stakan suv iching',
        _waterHours[i],
        0,
      );
    }
  }
}
