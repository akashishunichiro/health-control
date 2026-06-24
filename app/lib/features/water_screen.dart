import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../core/util.dart';
import '../data/app_state.dart';
import '../widgets/common.dart';

class WaterScreen extends ConsumerWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appProvider);
    final app = ref.read(appProvider.notifier);
    final today = DateTime.now();
    final water = app.waterOn(today);
    final goal = app.profile.waterGoalMl;
    final labels =
        app.last7Days.map((d) => kWeekdaysUz[d.weekday - 1]).toList();

    final amounts = [200, 250, 300, 500];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suv'),
        actions: [
          IconButton(
            tooltip: 'Bugungini tozalash',
            onPressed: () => app.resetWaterToday(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ProgressRing(
              progress: goal > 0 ? water / goal : 0,
              color: AppColors.water,
              size: 180,
              stroke: 16,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$water',
                      style: const TextStyle(
                          fontSize: 34, fontWeight: FontWeight.bold)),
                  Text('/ $goal ml',
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader('Tezkor qo\'shish'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final a in amounts)
                ActionChip(
                  avatar: const Icon(Icons.water_drop, color: AppColors.water),
                  label: Text('+$a ml'),
                  onPressed: () => app.addWater(a),
                ),
              ActionChip(
                avatar: const Icon(Icons.local_drink, color: AppColors.water),
                label: const Text('+1 stakan'),
                onPressed: () => app.addWater(250),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader('Haftalik (ml)'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MiniBarChart(
                values: app.weeklyWater,
                labels: labels,
                color: AppColors.water,
                valueLabel: (v) => '${v.round()}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
