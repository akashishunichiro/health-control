import 'package:hive_flutter/hive_flutter.dart';

/// Barcha Hive box'lari shu yerda ochiladi.
/// Yozuvlar oddiy Map ko'rinishida saqlanadi — codegen (build_runner) kerak emas.
class Db {
  static late Box meals;
  static late Box water;
  static late Box sleep;
  static late Box steps;
  static late Box weight;
  static late Box medications;
  static late Box medIntakes;
  static late Box vitals;
  static late Box settings;

  static Future<void> init() async {
    await Hive.initFlutter();
    meals = await Hive.openBox('meals');
    water = await Hive.openBox('water');
    sleep = await Hive.openBox('sleep');
    steps = await Hive.openBox('steps');
    weight = await Hive.openBox('weight');
    medications = await Hive.openBox('medications');
    medIntakes = await Hive.openBox('med_intakes');
    vitals = await Hive.openBox('vitals');
    settings = await Hive.openBox('settings');
  }
}
