// Health Control — ma'lumotlar modellari.
// Hive untyped box'larda Map ko'rinishida saqlanadi (codegen kerak emas).

class Meal {
  final String id;
  final String type; // breakfast | lunch | dinner | snack
  final String name;
  final double grams;
  final double calories;
  final int dateMillis;

  Meal({
    required this.id,
    required this.type,
    required this.name,
    required this.grams,
    required this.calories,
    required this.dateMillis,
  });

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(dateMillis);

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'name': name,
        'grams': grams,
        'calories': calories,
        'dateMillis': dateMillis,
      };

  factory Meal.fromMap(Map m) => Meal(
        id: m['id'] as String,
        type: m['type'] as String,
        name: m['name'] as String,
        grams: (m['grams'] as num).toDouble(),
        calories: (m['calories'] as num).toDouble(),
        dateMillis: m['dateMillis'] as int,
      );
}

class WaterLog {
  final String id;
  final int ml;
  final int dateMillis;

  WaterLog({required this.id, required this.ml, required this.dateMillis});

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(dateMillis);

  Map<String, dynamic> toMap() =>
      {'id': id, 'ml': ml, 'dateMillis': dateMillis};

  factory WaterLog.fromMap(Map m) => WaterLog(
        id: m['id'] as String,
        ml: m['ml'] as int,
        dateMillis: m['dateMillis'] as int,
      );
}

class SleepLog {
  final String id;
  final int bedMillis;
  final int wakeMillis;
  final int quality; // 0 yomon, 1 o'rtacha, 2 yaxshi

  SleepLog({
    required this.id,
    required this.bedMillis,
    required this.wakeMillis,
    required this.quality,
  });

  DateTime get bed => DateTime.fromMillisecondsSinceEpoch(bedMillis);
  DateTime get wake => DateTime.fromMillisecondsSinceEpoch(wakeMillis);
  double get hours => (wakeMillis - bedMillis) / 3600000.0;

  Map<String, dynamic> toMap() => {
        'id': id,
        'bedMillis': bedMillis,
        'wakeMillis': wakeMillis,
        'quality': quality,
      };

  factory SleepLog.fromMap(Map m) => SleepLog(
        id: m['id'] as String,
        bedMillis: m['bedMillis'] as int,
        wakeMillis: m['wakeMillis'] as int,
        quality: m['quality'] as int,
      );
}

/// Bir kunga bitta yozuv. id = sana kaliti (yyyy-MM-dd).
class StepsLog {
  final String id; // dateKey
  final int steps;

  StepsLog({required this.id, required this.steps});

  Map<String, dynamic> toMap() => {'id': id, 'steps': steps};

  factory StepsLog.fromMap(Map m) =>
      StepsLog(id: m['id'] as String, steps: m['steps'] as int);
}

class WeightLog {
  final String id;
  final double kg;
  final int dateMillis;

  WeightLog({required this.id, required this.kg, required this.dateMillis});

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(dateMillis);

  Map<String, dynamic> toMap() => {'id': id, 'kg': kg, 'dateMillis': dateMillis};

  factory WeightLog.fromMap(Map m) => WeightLog(
        id: m['id'] as String,
        kg: (m['kg'] as num).toDouble(),
        dateMillis: m['dateMillis'] as int,
      );
}

class Medication {
  final String id;
  final String name;
  final String dose;
  final List<String> times; // ["08:00", "20:00"]

  Medication({
    required this.id,
    required this.name,
    required this.dose,
    required this.times,
  });

  Map<String, dynamic> toMap() =>
      {'id': id, 'name': name, 'dose': dose, 'times': times};

  factory Medication.fromMap(Map m) => Medication(
        id: m['id'] as String,
        name: m['name'] as String,
        dose: m['dose'] as String,
        times: (m['times'] as List).map((e) => e.toString()).toList(),
      );
}

/// Dori qabuli belgisi. id = "medId|dateKey|time".
class MedIntake {
  final String id;
  final bool taken;

  MedIntake({required this.id, required this.taken});

  Map<String, dynamic> toMap() => {'id': id, 'taken': taken};

  factory MedIntake.fromMap(Map m) =>
      MedIntake(id: m['id'] as String, taken: m['taken'] as bool);
}
