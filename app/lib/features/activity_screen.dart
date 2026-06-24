import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../core/util.dart';
import '../data/app_state.dart';
import '../widgets/common.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  final _steps = TextEditingController();

  @override
  void dispose() {
    _steps.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appProvider);
    final app = ref.read(appProvider.notifier);
    final today = DateTime.now();
    final steps = app.stepsOn(today);
    final goal = app.profile.stepGoal;
    final km = steps * 0.0008; // ~0.8 m / qadam
    final kcal = steps * 0.04;
    final labels =
        app.last7Days.map((d) => kWeekdaysUz[d.weekday - 1]).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Faollik / Yurish')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ProgressRing(
              progress: goal > 0 ? steps / goal : 0,
              color: AppColors.activity,
              size: 180,
              stroke: 16,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$steps',
                      style: const TextStyle(
                          fontSize: 34, fontWeight: FontWeight.bold)),
                  Text('/ $goal qadam',
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _stat('Masofa', '${km.toStringAsFixed(2)} km',
                    Icons.straighten),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _stat('Kaloriya', '${kcal.round()} kkal',
                    Icons.local_fire_department),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionHeader('Qadamlarni kiritish'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _steps,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Bugungi qadamlar soni'),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: () {
                  final v = int.tryParse(_steps.text.trim());
                  if (v != null) {
                    app.setSteps(today, v);
                    _steps.clear();
                    FocusScope.of(context).unfocus();
                  }
                },
                child: const Text('Saqlash'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: [
              for (final inc in [500, 1000, 2000])
                ActionChip(
                  label: Text('+$inc'),
                  onPressed: () => app.setSteps(today, steps + inc),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionHeader('Haftalik qadamlar'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MiniBarChart(
                values: app.weeklySteps,
                labels: labels,
                color: AppColors.activity,
                valueLabel: (v) => v >= 1000
                    ? '${(v / 1000).toStringAsFixed(1)}k'
                    : '${v.round()}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.activity),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
