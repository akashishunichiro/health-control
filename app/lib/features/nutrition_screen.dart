import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../data/app_state.dart';
import '../data/models.dart';
import '../widgets/common.dart';
import 'add_meal_screen.dart';

const Map<String, String> kMealTypes = {
  'breakfast': 'Nonushta',
  'lunch': 'Tushlik',
  'dinner': 'Kechki ovqat',
  'snack': 'Tamaddi',
};

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appProvider);
    final app = ref.read(appProvider.notifier);
    final today = DateTime.now();
    final meals = app.mealsOn(today);
    final cal = app.caloriesOn(today);
    final goal = app.calorieGoal;
    final left = (goal - cal);

    final byType = <String, List<Meal>>{};
    for (final m in meals) {
      byType.putIfAbsent(m.type, () => []).add(m);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ovqatlanish')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddMealScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Ovqat'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ProgressRing(
                    progress: goal > 0 ? cal / goal : 0,
                    color: AppColors.food,
                    size: 110,
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${cal.round()}',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        const Text('kkal', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kunlik me\'yor: ${goal.round()} kkal',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(
                          left >= 0
                              ? 'Qoldi: ${left.round()} kkal'
                              : 'Me\'yordan ${(-left).round()} kkal oshdi',
                          style: TextStyle(
                              color: left >= 0
                                  ? AppColors.activity
                                  : AppColors.med),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (meals.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text('Bugun hali ovqat qo\'shilmagan.\n"+ Ovqat" tugmasini bosing.',
                    textAlign: TextAlign.center),
              ),
            ),
          for (final type in kMealTypes.keys)
            if ((byType[type] ?? []).isNotEmpty) ...[
              SectionHeader(
                kMealTypes[type]!,
                trailing: Text(
                  '${(byType[type]!).fold<double>(0, (s, m) => s + m.calories).round()} kkal',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...byType[type]!.map((m) => Card(
                    child: ListTile(
                      title: Text(m.name),
                      subtitle:
                          Text('${m.grams.round()} g • ${m.calories.round()} kkal'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => app.deleteMeal(m.id),
                      ),
                    ),
                  )),
              const SizedBox(height: 4),
            ],
        ],
      ),
    );
  }
}
