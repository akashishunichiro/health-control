import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_state.dart';
import '../data/backup.dart';
import '../data/report_pdf.dart';
import '../data/settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final sNotifier = ref.read(settingsProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sozlamalar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Mavzu'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                        value: ThemeMode.system, label: Text('Tizim')),
                    ButtonSegment(
                        value: ThemeMode.light, label: Text('Yorug\'')),
                    ButtonSegment(
                        value: ThemeMode.dark, label: Text('Qorong\'i')),
                  ],
                  selected: {s.themeMode},
                  onSelectionChanged: (set) => sNotifier.setTheme(set.first),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _section('Vazn birligi'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Kilogramm (kg)'),
                    selected: s.weightUnit == 'kg',
                    onSelected: (_) => sNotifier.setWeightUnit('kg'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Funt (lb)'),
                    selected: s.weightUnit == 'lb',
                    onSelected: (_) => sNotifier.setWeightUnit('lb'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _section('Til'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('O\'zbekcha'),
              subtitle: const Text('Rus / Ingliz tez orada qo\'shiladi'),
              onTap: () => messenger.showSnackBar(const SnackBar(
                  content: Text('Hozircha faqat o\'zbek tili mavjud'))),
            ),
          ),
          const SizedBox(height: 12),
          _section('Hisobot'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('PDF hisobot yaratish'),
              subtitle: const Text('Shifokorga yuborish uchun'),
              onTap: () async {
                try {
                  await HealthReport.generateAndShare(
                      ref.read(appProvider.notifier));
                } catch (e) {
                  messenger.showSnackBar(
                      SnackBar(content: Text('Xatolik: $e')));
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          _section('Zaxira nusxa'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: const Text('Ma\'lumotlarni eksport qilish'),
                  subtitle: const Text('JSON fayl sifatida saqlash/ulashish'),
                  onTap: () async {
                    try {
                      await Backup.exportData();
                    } catch (e) {
                      messenger.showSnackBar(
                          SnackBar(content: Text('Xatolik: $e')));
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Zaxiradan tiklash'),
                  subtitle: const Text('JSON fayldan import qilish'),
                  onTap: () async {
                    try {
                      final ok = await Backup.importData();
                      if (ok) {
                        ref.invalidate(appProvider);
                        ref.invalidate(settingsProvider);
                        messenger.showSnackBar(const SnackBar(
                            content: Text('Ma\'lumotlar tiklandi')));
                      }
                    } catch (e) {
                      messenger.showSnackBar(
                          SnackBar(content: Text('Xatolik: $e')));
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text('Salomatlik v1.0',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
}
