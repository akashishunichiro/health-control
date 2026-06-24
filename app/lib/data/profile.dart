import '../core/util.dart';

/// Foydalanuvchi profili va maqsadlari.
class Profile {
  final String name;
  final String gender; // male | female
  final int age;
  final double heightCm;
  final double weightKg;
  final String activity; // low | medium | high
  final int waterGoalMl;
  final int stepGoal;
  final double sleepGoalH;

  const Profile({
    required this.name,
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.activity,
    required this.waterGoalMl,
    required this.stepGoal,
    required this.sleepGoalH,
  });

  factory Profile.def() => const Profile(
        name: 'Foydalanuvchi',
        gender: 'male',
        age: 25,
        heightCm: 175,
        weightKg: 70,
        activity: 'medium',
        waterGoalMl: 2000,
        stepGoal: 8000,
        sleepGoalH: 8,
      );

  double get calorieGoal => calorieGoal2(this);

  Profile copyWith({
    String? name,
    String? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    String? activity,
    int? waterGoalMl,
    int? stepGoal,
    double? sleepGoalH,
  }) =>
      Profile(
        name: name ?? this.name,
        gender: gender ?? this.gender,
        age: age ?? this.age,
        heightCm: heightCm ?? this.heightCm,
        weightKg: weightKg ?? this.weightKg,
        activity: activity ?? this.activity,
        waterGoalMl: waterGoalMl ?? this.waterGoalMl,
        stepGoal: stepGoal ?? this.stepGoal,
        sleepGoalH: sleepGoalH ?? this.sleepGoalH,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'gender': gender,
        'age': age,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'activity': activity,
        'waterGoalMl': waterGoalMl,
        'stepGoal': stepGoal,
        'sleepGoalH': sleepGoalH,
      };

  factory Profile.fromMap(Map m) => Profile(
        name: (m['name'] ?? 'Foydalanuvchi') as String,
        gender: (m['gender'] ?? 'male') as String,
        age: (m['age'] ?? 25) as int,
        heightCm: ((m['heightCm'] ?? 175) as num).toDouble(),
        weightKg: ((m['weightKg'] ?? 70) as num).toDouble(),
        activity: (m['activity'] ?? 'medium') as String,
        waterGoalMl: (m['waterGoalMl'] ?? 2000) as int,
        stepGoal: (m['stepGoal'] ?? 8000) as int,
        sleepGoalH: ((m['sleepGoalH'] ?? 8) as num).toDouble(),
      );
}

double calorieGoal2(Profile p) => calorieGoal(
      gender: p.gender,
      age: p.age,
      heightCm: p.heightCm,
      weightKg: p.weightKg,
      activity: p.activity,
    );
