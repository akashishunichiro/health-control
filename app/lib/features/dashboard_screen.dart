import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../core/util.dart';
import '../data/app_state.dart';
import '../data/settings.dart';
import '../widgets/common.dart';
import 'water_screen.dart';
import 'weight_screen.dart';
import 'medication_screen.dart';

class DashboardScreen extends ConsumerWidget {
  final void Function(int) onOpenTab;
  const DashboardScreen({super.key, required this.onOpenTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appProvider);
    final app = ref.read(appProvider.notifier);
    final today = DateTime.now();
    final p = app.profile;
    final unit = ref.watch(settingsProvider).weightUnit;

    final cal = app.caloriesOn(today);
    final calGoal = app.calorieGoal;
    final water = app.waterOn(today);
    final steps = app.stepsOn(today);
    final sleep = app.sleepFor(today);
    final weight = app.latestWeight;

    int medsTotal = 0, medsTaken = 0;
    for (final m in app.medications) {
      for (final t in m.times) {
        medsTotal++;
        if (app.isTaken(m.id, today, t)) medsTaken++;
      }
    }

    final labels = app.last7Days
        .map((d) => kWeekdaysUz[d.weekday - 1])
        .toList();

    void push(Widget w) => Navigator.push(
        context, MaterialPageRoute(builder: (_) => w));

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Assalomu alaykum,',
                style: Theme.of(context).textTheme.bodyMedium),
            Text(p.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              'Bugun: ${today.day}.${today.month}.${today.year}',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                MetricCard(
                  icon: Icons.local_fire_department,
                  color: AppColors.food,
                  title: 'Kaloriya',
                  value: '${cal.round()}',
                  subtitle: 'Maqsad: ${calGoal.round()} kkal',
                  progress: calGoal > 0 ? cal / calGoal : 0,
                  onTap: () => onOpenTab(1),
                ),
                MetricCard(
                  icon: Icons.water_drop,
                  color: AppColors.water,
                  title: 'Suv',
                  value: '$water ml',
                  subtitle: 'Maqsad: ${p.waterGoalMl} ml',
                  progress:
                      p.waterGoalMl > 0 ? water / p.waterGoalMl : 0,
                  onTap: () => push(const WaterScreen()),
                ),
                MetricCard(
                  icon: Icons.directions_walk,
                  color: AppColors.activity,
                  title: 'Qadamlar',
                  value: '$steps',
                  subtitle: 'Maqsad: ${p.stepGoal}',
                  progress: p.stepGoal > 0 ? steps / p.stepGoal : 0,
                  onTap: () => onOpenTab(2),
                ),
                MetricCard(
                  icon: Icons.bedtime,
                  color: AppColors.sleep,
                  title: 'Uyqu',
                  value: sleep == null
                      ? '—'
                      : '${sleep.hours.toStringAsFixed(1)} s',
                  subtitle: 'Maqsad: ${p.sleepGoalH.toStringAsFixed(0)} s',
                  progress: sleep == null
                      ? 0
                      : sleep.hours / p.sleepGoalH,
                  onTap: () => onOpenTab(3),
                ),
                MetricCard(
                  icon: Icons.monitor_weight,
                  color: AppColors.weight,
                  title: 'Vazn',
                  value: weight == null
                      ? '—'
                      : '${kgToDisplay(weight, unit).toStringAsFixed(1)} ${weightUnitLabel(unit)}',
                  subtitle: weight == null
                      ? 'Kiritilmagan'
                      : 'TVI: ${bmi(weight, p.heightCm).toStringAsFixed(1)}',
                  onTap: () => push(const WeightScreen()),
                ),
                MetricCard(
                  icon: Icons.medication,
                  color: AppColors.med,
                  title: 'Dori',
                  value: medsTotal == 0 ? '—' : '$medsTaken/$medsTotal',
                  subtitle: medsTotal == 0
                      ? 'Qo\'shilmagan'
                      : 'Bugun ichilgan',
                  progress: medsTotal > 0 ? medsTaken / medsTotal : null,
                  onTap: () => push(const MedicationScreen()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const SectionHeader('Haftalik qadamlar'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MiniBarChart(
                  values: app.weeklySteps,
                  labels: labels,
                  color: AppColors.activity,
                  valueLabel: (v) =>
                      v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}k' : '${v.round()}',
                ),
              ),
            ),
            const SizedBox(height: 8),
            const SectionHeader('Haftalik kaloriya'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MiniBarChart(
                  values: app.weeklyCalories,
                  labels: labels,
                  color: AppColors.food,
                  valueLabel: (v) => '${v.round()}',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bu ilova tibbiy maslahat bermaydi va tashxis qo\'ymaydi. '
                      'Faqat shaxsiy kuzatuv uchun.',
                      style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
