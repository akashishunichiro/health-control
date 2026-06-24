import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/util.dart';
import '../data/app_state.dart';
import '../data/db.dart';
import '../data/notifications.dart';
import '../data/profile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _name;
  late TextEditingController _age;
  late TextEditingController _height;
  late TextEditingController _weight;
  late TextEditingController _waterGoal;
  late TextEditingController _stepGoal;
  late TextEditingController _sleepGoal;
  late String _gender;
  late String _activity;
  bool _waterReminder = false;

  @override
  void initState() {
    super.initState();
    _waterReminder = Db.settings.get('water_reminder') == true;
    final p = ref.read(appProvider.notifier).profile;
    _name = TextEditingController(text: p.name);
    _age = TextEditingController(text: '${p.age}');
    _height = TextEditingController(text: '${p.heightCm.round()}');
    _weight = TextEditingController(text: '${p.weightKg.round()}');
    _waterGoal = TextEditingController(text: '${p.waterGoalMl}');
    _stepGoal = TextEditingController(text: '${p.stepGoal}');
    _sleepGoal = TextEditingController(text: '${p.sleepGoalH.round()}');
    _gender = p.gender;
    _activity = p.activity;
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _height.dispose();
    _weight.dispose();
    _waterGoal.dispose();
    _stepGoal.dispose();
    _sleepGoal.dispose();
    super.dispose();
  }

  int _i(TextEditingController c, int d) => int.tryParse(c.text.trim()) ?? d;
  double _f(TextEditingController c, double d) =>
      double.tryParse(c.text.trim().replaceAll(',', '.')) ?? d;

  Profile _current() => Profile(
        name: _name.text.trim().isEmpty ? 'Foydalanuvchi' : _name.text.trim(),
        gender: _gender,
        age: _i(_age, 25),
        heightCm: _f(_height, 175),
        weightKg: _f(_weight, 70),
        activity: _activity,
        waterGoalMl: _i(_waterGoal, 2000),
        stepGoal: _i(_stepGoal, 8000),
        sleepGoalH: _f(_sleepGoal, 8),
      );

  void _save() {
    final p = _current();
    ref.read(appProvider.notifier).saveProfile(p);
    // Vazn maydoni profil orqali ham yozuvga aylansin (agar bo'sh bo'lsa).
    if (ref.read(appProvider.notifier).latestWeight == null) {
      ref.read(appProvider.notifier).addWeight(p.weightKg);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profil saqlandi')));
  }

  @override
  Widget build(BuildContext context) {
    final goal = _current().calorieGoal;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Ism'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          const Text('Jins'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Erkak'),
                selected: _gender == 'male',
                onSelected: (_) => setState(() => _gender = 'male'),
              ),
              ChoiceChip(
                label: const Text('Ayol'),
                selected: _gender == 'female',
                onSelected: (_) => setState(() => _gender = 'female'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _num(_age, 'Yosh')),
              const SizedBox(width: 12),
              Expanded(child: _num(_height, 'Bo\'y (sm)')),
              const SizedBox(width: 12),
              Expanded(child: _num(_weight, 'Vazn (kg)')),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Faollik darajasi'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              _act('low', 'Past'),
              _act('medium', 'O\'rtacha'),
              _act('high', 'Yuqori'),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tavsiya etilgan kunlik kaloriya: ${goal.round()} kkal\n'
                      'TVI: ${bmi(_f(_weight, 70), _f(_height, 175)).toStringAsFixed(1)} '
                      '(${bmiLabel(bmi(_f(_weight, 70), _f(_height, 175)))})',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Maqsadlar',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _num(_waterGoal, 'Suv (ml)')),
              const SizedBox(width: 12),
              Expanded(child: _num(_stepGoal, 'Qadam')),
              const SizedBox(width: 12),
              Expanded(child: _num(_sleepGoal, 'Uyqu (s)')),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Eslatmalar',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Suv ichish eslatmasi'),
              subtitle: const Text('Kuniga 5 marta (9:00–21:00)'),
              value: _waterReminder,
              onChanged: (v) {
                setState(() => _waterReminder = v);
                Db.settings.put('water_reminder', v);
                Notifications.scheduleWaterReminders(v);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(v
                          ? 'Suv eslatmasi yoqildi'
                          : 'Suv eslatmasi o\'chirildi')),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Eslatma: dori qo\'shilganda eslatmalari avtomatik o\'rnatiladi.',
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: const Text('Saqlash')),
        ],
      ),
    );
  }

  Widget _num(TextEditingController c, String label) => TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        onChanged: (_) => setState(() {}),
      );

  Widget _act(String key, String label) => ChoiceChip(
        label: Text(label),
        selected: _activity == key,
        onSelected: (_) => setState(() => _activity = key),
      );
}
