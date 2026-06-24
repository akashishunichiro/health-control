// Sana va salomatlik hisob-kitoblari uchun yordamchilar.

String _two(int n) => n < 10 ? '0$n' : '$n';

/// yyyy-MM-dd ko'rinishidagi kun kaliti.
String dateKey(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

const List<String> kWeekdaysUz = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];

String hhmm(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';

/// Mifflin–St Jeor formulasi bo'yicha kunlik kaloriya me'yori (TDEE).
double calorieGoal({
  required String gender,
  required int age,
  required double heightCm,
  required double weightKg,
  required String activity,
}) {
  final s = gender == 'male' ? 5.0 : -161.0;
  final bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + s;
  final factor = activity == 'low'
      ? 1.375
      : activity == 'high'
          ? 1.725
          : 1.55;
  return bmr * factor;
}

/// Tana vazni indeksi (BMI / TVI).
double bmi(double weightKg, double heightCm) {
  if (heightCm <= 0) return 0;
  final m = heightCm / 100.0;
  return weightKg / (m * m);
}

String bmiLabel(double v) {
  if (v < 18.5) return 'Kam vazn';
  if (v < 25) return 'Normada';
  if (v < 30) return 'Ortiqcha vazn';
  return 'Semizlik';
}
