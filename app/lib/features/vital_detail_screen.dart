import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/util.dart';
import '../data/app_state.dart';
import '../data/vital_types.dart';

class VitalDetailScreen extends ConsumerStatefulWidget {
  final String typeKey;
  const VitalDetailScreen({super.key, required this.typeKey});

  @override
  ConsumerState<VitalDetailScreen> createState() => _VitalDetailScreenState();
}

class _VitalDetailScreenState extends ConsumerState<VitalDetailScreen> {
  final _v1 = TextEditingController();
  final _v2 = TextEditingController();
  int _mood = 3;

  @override
  void dispose() {
    _v1.dispose();
    _v2.dispose();
    super.dispose();
  }

  double _d(String s) => double.tryParse(s.trim().replaceAll(',', '.')) ?? -1;

  void _save(VitalTypeInfo t) {
    final app = ref.read(appProvider.notifier);
    if (t.isMood) {
      app.addVital(t.key, _mood.toDouble());
      return;
    }
    final v1 = _d(_v1.text);
    if (v1 < 0) {
      _msg('Qiymatni to\'g\'ri kiriting');
      return;
    }
    if (t.dual) {
      final v2 = _d(_v2.text);
      if (v2 < 0) {
        _msg('Ikkala qiymatni kiriting');
        return;
      }
      app.addVital(t.key, v1, v2: v2);
    } else {
      app.addVital(t.key, v1);
    }
    _v1.clear();
    _v2.clear();
    FocusScope.of(context).unfocus();
  }

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  @override
  Widget build(BuildContext context) {
    ref.watch(appProvider);
    final app = ref.read(appProvider.notifier);
    final t = vitalInfo(widget.typeKey);
    final history = app.vitalsOfType(t.key);

    return Scaffold(
      appBar: AppBar(title: Text(t.label)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Yangi qiymat kiritish',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: t.color)),
                  const SizedBox(height: 12),
                  if (t.isMood)
                    Wrap(
                      spacing: 6,
                      children: List.generate(
                        kMoodEmojis.length,
                        (i) => ChoiceChip(
                          label: Text('${kMoodEmojis[i]} ${kMoodLabels[i]}'),
                          selected: _mood == i,
                          onSelected: (_) => setState(() => _mood = i),
                        ),
                      ),
                    )
                  else if (t.dual)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _v1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Yuqori (sistolik)'),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('/'),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _v2,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Quyi (diastolik)'),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _v1,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration:
                          InputDecoration(labelText: 'Qiymat (${t.unit})'),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _save(t),
                      child: const Text('Saqlash'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text('Tarix',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (history.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('Hali yozuv yo\'q')),
            ),
          ...history.map((v) {
            final st = vitalStatus(v);
            final d = v.date;
            return Card(
              child: ListTile(
                leading: Icon(t.icon, color: t.color),
                title: Text(
                  t.isMood
                      ? '${vitalValueText(v)} ${kMoodLabels[v.v1.round().clamp(0, 4)]}'
                      : '${vitalValueText(v)} ${t.unit}',
                ),
                subtitle: Text(
                  '${d.day}.${d.month}.${d.year} ${hhmm(d)}'
                  '${st != null ? ' • ${st.$1}' : ''}',
                  style: TextStyle(color: st?.$2),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => app.deleteVital(v.id),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
