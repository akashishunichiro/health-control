import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_state.dart';

class AddMedicationScreen extends ConsumerStatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  ConsumerState<AddMedicationScreen> createState() =>
      _AddMedicationScreenState();
}

class _AddMedicationScreenState extends ConsumerState<AddMedicationScreen> {
  final _name = TextEditingController();
  final _dose = TextEditingController();
  final List<TimeOfDay> _times = [const TimeOfDay(hour: 8, minute: 0)];

  @override
  void dispose() {
    _name.dispose();
    _dose.dispose();
    super.dispose();
  }

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dori nomini kiriting')));
      return;
    }
    if (_times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kamida bitta vaqt qo\'shing')));
      return;
    }
    final times = _times.map(_fmt).toList()..sort();
    ref
        .read(appProvider.notifier)
        .addMedication(name, _dose.text.trim(), times);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dori qo\'shish')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Dori nomi'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dose,
            decoration: const InputDecoration(
                labelText: 'Doza (masalan: 1 tabletka)'),
          ),
          const SizedBox(height: 20),
          const Text('Qabul vaqtlari',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._times.asMap().entries.map((e) => InputChip(
                    label: Text(_fmt(e.value)),
                    onDeleted: () => setState(() => _times.removeAt(e.key)),
                  )),
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: const Text('Vaqt'),
                onPressed: () async {
                  final t = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 12, minute: 0));
                  if (t != null) setState(() => _times.add(t));
                },
              ),
            ],
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _save,
            child: const Text('Saqlash'),
          ),
        ],
      ),
    );
  }
}
