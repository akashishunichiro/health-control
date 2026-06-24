import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/util.dart';
import 'db.dart';
import 'models.dart';
import 'profile.dart';

/// Ilova holati: profil + o'zgarish hisoblagichi (rev).
/// Har bir yozish amalidan keyin rev oshadi va UI qayta chiziladi.
class AppState {
  final Profile profile;
  final int rev;
  const AppState(this.profile, this.rev);
}

final appProvider =
    NotifierProvider<AppNotifier, AppState>(AppNotifier.new);

class AppNotifier extends Notifier<AppState> {
  @override
  AppState build() => AppState(_loadProfile(), 0);

  Profile _loadProfile() {
    final m = Db.settings.get('profile');
    if (m == null) return Profile.def();
    return Profile.fromMap(Map.from(m));
  }

  void _bump() => state = AppState(state.profile, state.rev + 1);

  String _id() => DateTime.now().microsecondsSinceEpoch.toString();
  int get _now => DateTime.now().millisecondsSinceEpoch;

  // ---------------- Profil ----------------
  Profile get profile => state.profile;

  void saveProfile(Profile p) {
    Db.settings.put('profile', p.toMap());
    state = AppState(p, state.rev + 1);
  }

  double get calorieGoal => state.profile.calorieGoal;

  // ---------------- Ovqat ----------------
  List<Meal> mealsOn(DateTime day) {
    final list = Db.meals.values
        .map((e) => Meal.fromMap(Map.from(e)))
        .where((m) => sameDay(m.date, day))
        .toList();
    list.sort((a, b) => a.dateMillis.compareTo(b.dateMillis));
    return list;
  }

  void addMeal({
    required String type,
    required String name,
    required double grams,
    required double calories,
    DateTime? when,
  }) {
    final id = _id();
    Db.meals.put(
      id,
      Meal(
        id: id,
        type: type,
        name: name,
        grams: grams,
        calories: calories,
        dateMillis: (when ?? DateTime.now()).millisecondsSinceEpoch,
      ).toMap(),
    );
    _bump();
  }

  void deleteMeal(String id) {
    Db.meals.delete(id);
    _bump();
  }

  double caloriesOn(DateTime day) =>
      mealsOn(day).fold(0.0, (s, m) => s + m.calories);

  // ---------------- Suv ----------------
  int waterOn(DateTime day) => Db.water.values
      .map((e) => WaterLog.fromMap(Map.from(e)))
      .where((w) => sameDay(w.date, day))
      .fold(0, (s, w) => s + w.ml);

  void addWater(int ml) {
    final id = _id();
    Db.water.put(id, WaterLog(id: id, ml: ml, dateMillis: _now).toMap());
    _bump();
  }

  void resetWaterToday() {
    final today = DateTime.now();
    for (final e in Db.water.values.toList()) {
      final w = WaterLog.fromMap(Map.from(e));
      if (sameDay(w.date, today)) Db.water.delete(w.id);
    }
    _bump();
  }

  // ---------------- Qadamlar ----------------
  int stepsOn(DateTime day) {
    final s = Db.steps.get(dateKey(day));
    return s == null ? 0 : StepsLog.fromMap(Map.from(s)).steps;
  }

  void setSteps(DateTime day, int value) {
    final k = dateKey(day);
    Db.steps.put(k, StepsLog(id: k, steps: value).toMap());
    _bump();
  }

  // ---------------- Uyqu ----------------
  List<SleepLog> get sleeps {
    final list =
        Db.sleep.values.map((e) => SleepLog.fromMap(Map.from(e))).toList();
    list.sort((a, b) => b.wakeMillis.compareTo(a.wakeMillis));
    return list;
  }

  /// Berilgan kunda uyg'ongan uyqu yozuvi.
  SleepLog? sleepFor(DateTime day) {
    for (final s in sleeps) {
      if (sameDay(s.wake, day)) return s;
    }
    return null;
  }

  void addSleep(DateTime bed, DateTime wake, int quality) {
    final id = _id();
    Db.sleep.put(
      id,
      SleepLog(
        id: id,
        bedMillis: bed.millisecondsSinceEpoch,
        wakeMillis: wake.millisecondsSinceEpoch,
        quality: quality,
      ).toMap(),
    );
    _bump();
  }

  void deleteSleep(String id) {
    Db.sleep.delete(id);
    _bump();
  }

  // ---------------- Vazn ----------------
  List<WeightLog> get weights {
    final list =
        Db.weight.values.map((e) => WeightLog.fromMap(Map.from(e))).toList();
    list.sort((a, b) => b.dateMillis.compareTo(a.dateMillis));
    return list;
  }

  double? get latestWeight => weights.isEmpty ? null : weights.first.kg;

  void addWeight(double kg) {
    final id = _id();
    Db.weight.put(id, WeightLog(id: id, kg: kg, dateMillis: _now).toMap());
    _bump();
  }

  void deleteWeight(String id) {
    Db.weight.delete(id);
    _bump();
  }

  // ---------------- Dori ----------------
  List<Medication> get medications =>
      Db.medications.values.map((e) => Medication.fromMap(Map.from(e))).toList();

  String addMedication(String name, String dose, List<String> times) {
    final id = _id();
    Db.medications.put(
      id,
      Medication(id: id, name: name, dose: dose, times: times).toMap(),
    );
    _bump();
    return id;
  }

  void deleteMedication(String id) {
    Db.medications.delete(id);
    _bump();
  }

  String _intakeKey(String medId, DateTime day, String time) =>
      '$medId|${dateKey(day)}|$time';

  bool isTaken(String medId, DateTime day, String time) {
    final m = Db.medIntakes.get(_intakeKey(medId, day, time));
    return m != null && MedIntake.fromMap(Map.from(m)).taken;
  }

  void toggleTaken(String medId, DateTime day, String time) {
    final key = _intakeKey(medId, day, time);
    final cur = isTaken(medId, day, time);
    Db.medIntakes.put(key, MedIntake(id: key, taken: !cur).toMap());
    _bump();
  }

  // ---------------- Sog'liq ko'rsatkichlari (vitals) ----------------
  List<Vital> vitalsOfType(String type) {
    final list = Db.vitals.values
        .map((e) => Vital.fromMap(Map.from(e)))
        .where((v) => v.type == type)
        .toList();
    list.sort((a, b) => b.dateMillis.compareTo(a.dateMillis));
    return list;
  }

  Vital? latestVital(String type) {
    final l = vitalsOfType(type);
    return l.isEmpty ? null : l.first;
  }

  void addVital(String type, double v1, {double v2 = 0, String note = ''}) {
    final id = _id();
    Db.vitals.put(
      id,
      Vital(id: id, type: type, v1: v1, v2: v2, dateMillis: _now, note: note)
          .toMap(),
    );
    _bump();
  }

  void deleteVital(String id) {
    Db.vitals.delete(id);
    _bump();
  }

  // ---------------- Haftalik seriyalar (grafiklar uchun) ----------------
  List<DateTime> get last7Days {
    final today = dayStart(DateTime.now());
    return List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
  }

  List<double> get weeklyCalories =>
      last7Days.map((d) => caloriesOn(d)).toList();
  List<double> get weeklyWater =>
      last7Days.map((d) => waterOn(d).toDouble()).toList();
  List<double> get weeklySteps =>
      last7Days.map((d) => stepsOn(d).toDouble()).toList();
  List<double> get weeklySleep => last7Days.map((d) {
        final s = sleepFor(d);
        return s == null ? 0.0 : s.hours;
      }).toList();
}
