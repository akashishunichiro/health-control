import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../data/app_state.dart';
import '../data/food_catalog.dart';
import 'nutrition_screen.dart' show kMealTypes;

class AddMealScreen extends ConsumerStatefulWidget {
  const AddMealScreen({super.key});

  @override
  ConsumerState<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  String _type = 'breakfast';
  bool _custom = false;
  FoodItem? _selected;

  final _search = TextEditingController();
  final _grams = TextEditingController(text: '100');
  final _customName = TextEditingController();
  final _customKcal = TextEditingController();

  double _d(String s) => double.tryParse(s.trim().replaceAll(',', '.')) ?? 0;
  double get _gramsVal => _d(_grams.text);
  double get _kcalPer100 =>
      _custom ? _d(_customKcal.text) : (_selected?.kcalPer100g ?? 0);
  double get _calc => _kcalPer100 * _gramsVal / 100.0;

  @override
  void dispose() {
    _search.dispose();
    _grams.dispose();
    _customName.dispose();
    _customKcal.dispose();
    super.dispose();
  }

  void _save() {
    final name =
        _custom ? _customName.text.trim() : (_selected?.name ?? '');
    if (name.isEmpty) {
      _msg('Ovqat nomini tanlang yoki kiriting');
      return;
    }
    if (_gramsVal <= 0) {
      _msg('Porsiyani (gramm) to\'g\'ri kiriting');
      return;
    }
    ref.read(appProvider.notifier).addMeal(
          type: _type,
          name: name,
          grams: _gramsVal,
          calories: _calc,
        );
    Navigator.pop(context);
  }

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();
    final filtered = kFoodCatalog
        .where((f) => f.name.toLowerCase().contains(q))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Ovqat qo\'shish')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Ovqat turi'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: kMealTypes.entries
                      .map((e) => ChoiceChip(
                            label: Text(e.value),
                            selected: _type == e.key,
                            onSelected: (_) => setState(() => _type = e.key),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Bazadan')),
                    ButtonSegment(value: true, label: Text('Qo\'lda')),
                  ],
                  selected: {_custom},
                  onSelectionChanged: (s) =>
                      setState(() => _custom = s.first),
                ),
                const SizedBox(height: 16),
                if (!_custom) ...[
                  TextField(
                    controller: _search,
                    decoration: const InputDecoration(
                      hintText: 'Ovqat qidirish...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  ...filtered.map((f) => Card(
                        child: ListTile(
                          selected: _selected?.name == f.name,
                          selectedTileColor:
                              AppColors.food.withValues(alpha: 0.12),
                          title: Text(f.name),
                          subtitle: Text('${f.kcalPer100g.round()} kkal / 100 g'),
                          trailing: _selected?.name == f.name
                              ? const Icon(Icons.check_circle,
                                  color: AppColors.food)
                              : null,
                          onTap: () => setState(() => _selected = f),
                        ),
                      )),
                ] else ...[
                  TextField(
                    controller: _customName,
                    decoration: const InputDecoration(
                        labelText: 'Ovqat nomi'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _customKcal,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Kaloriya (100 g uchun, kkal)'),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ],
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: TextField(
                      controller: _grams,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Gramm', suffixText: 'g'),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Jami', style: TextStyle(fontSize: 11)),
                        Text('${_calc.round()} kkal',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Saqlash'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
