import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../core/util.dart';
import '../data/app_state.dart';
import '../widgets/common.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({super.key});

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  final _w = TextEditingController();

  @override
  void dispose() {
    _w.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appProvider);
    final app = ref.read(appProvider.notifier);
    final p = app.profile;
    final latest = app.latestWeight;
    final bmiVal = latest == null ? 0.0 : bmi(latest, p.heightCm);

    // Oxirgi 7 ta yozuv (eskidan yangiga) grafik uchun.
    final recent = app.weights.take(7).toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Vazn')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Joriy vazn'),
                      Text(
                        latest == null ? '—' : '${latest.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (latest != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('TVI (BMI)'),
                        Text(bmiVal.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        Text(bmiLabel(bmiVal),
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.weight)),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _w,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      const InputDecoration(labelText: 'Vazn (kg)'),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: () {
                  final v = double.tryParse(
                      _w.text.trim().replaceAll(',', '.'));
                  if (v != null && v > 0) {
                    app.addWeight(v);
                    _w.clear();
                    FocusScope.of(context).unfocus();
                  }
                },
                child: const Text('Qo\'shish'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (recent.length >= 2) ...[
            const SectionHeader('Vazn dinamikasi'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MiniBarChart(
                  values: recent.map((e) => e.kg).toList(),
                  labels: recent
                      .map((e) => '${e.date.day}.${e.date.month}')
                      .toList(),
                  color: AppColors.weight,
                  valueLabel: (v) => v.toStringAsFixed(0),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          const SectionHeader('Tarix'),
          ...app.weights.map((e) => Card(
                child: ListTile(
                  leading: const Icon(Icons.monitor_weight,
                      color: AppColors.weight),
                  title: Text('${e.kg.toStringAsFixed(1)} kg'),
                  subtitle: Text(
                      '${e.date.day}.${e.date.month}.${e.date.year}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => app.deleteWeight(e.id),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
