import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../core/util.dart';
import '../data/app_state.dart';
import '../widgets/common.dart';

const List<String> kQuality = ['Yomon', 'O\'rtacha', 'Yaxshi'];

class SleepScreen extends ConsumerStatefulWidget {
  const SleepScreen({super.key});

  @override
  ConsumerState<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends ConsumerState<SleepScreen> {
  TimeOfDay _bed = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wake = const TimeOfDay(hour: 7, minute: 0);
  int _quality = 2;

  (DateTime, DateTime) _range() {
    final now = DateTime.now();
    var wake = DateTime(now.year, now.month, now.day, _wake.hour, _wake.minute);
    var bed = DateTime(now.year, now.month, now.day, _bed.hour, _bed.minute);
    if (!bed.isBefore(wake)) bed = bed.subtract(const Duration(days: 1));
    return (bed, wake);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appProvider);
    final app = ref.read(appProvider.notifier);
    final goal = app.profile.sleepGoalH;
    final (bed, wake) = _range();
    final hours = wake.difference(bed).inMinutes / 60.0;
    final labels =
        app.last7Days.map((d) => kWeekdaysUz[d.weekday - 1]).toList();
    final history = app.sleeps.take(7).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Uyqu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _timeTile('Uyquga yotish', _bed, (t) => setState(() => _bed = t)),
                  const Divider(),
                  _timeTile('Uyg\'onish', _wake, (t) => setState(() => _wake = t)),
                  const SizedBox(height: 12),
                  Text('Davomiyligi: ${hours.toStringAsFixed(1)} soat',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: List.generate(
                      kQuality.length,
                      (i) => ChoiceChip(
                        label: Text(kQuality[i]),
                        selected: _quality == i,
                        onSelected: (_) => setState(() => _quality = i),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        app.addSleep(bed, wake, _quality);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Uyqu saqlandi')),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Uyquni saqlash'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SectionHeader('Haftalik (maqsad: ${goal.toStringAsFixed(0)} s)'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MiniBarChart(
                values: app.weeklySleep,
                labels: labels,
                color: AppColors.sleep,
                valueLabel: (v) => v.toStringAsFixed(1),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const SectionHeader('Tarix'),
          if (history.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('Hali yozuv yo\'q')),
            ),
          ...history.map((s) => Card(
                child: ListTile(
                  leading: const Icon(Icons.bedtime, color: AppColors.sleep),
                  title: Text('${s.hours.toStringAsFixed(1)} soat • ${kQuality[s.quality]}'),
                  subtitle: Text(
                      '${hhmm(s.bed)} → ${hhmm(s.wake)}  (${s.wake.day}.${s.wake.month})'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => app.deleteSleep(s.id),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _timeTile(String label, TimeOfDay value, ValueChanged<TimeOfDay> onPick) {
    return Row(
      children: [
        Text(label),
        const Spacer(),
        OutlinedButton.icon(
          icon: const Icon(Icons.access_time),
          label: Text(value.format(context)),
          onPressed: () async {
            final t = await showTimePicker(context: context, initialTime: value);
            if (t != null) onPick(t);
          },
        ),
      ],
    );
  }
}
