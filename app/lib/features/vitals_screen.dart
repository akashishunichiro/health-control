import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_state.dart';
import '../data/vital_types.dart';
import 'vital_detail_screen.dart';

class VitalsScreen extends ConsumerWidget {
  const VitalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appProvider);
    final app = ref.read(appProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Sog\'liq ko\'rsatkichlari')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: kVitalTypes.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final t = kVitalTypes[i];
          final last = app.latestVital(t.key);
          final status = last == null ? null : vitalStatus(last);
          return Card(
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              leading: CircleAvatar(
                backgroundColor: t.color.withValues(alpha: 0.15),
                child: Icon(t.icon, color: t.color),
              ),
              title: Text(t.label),
              subtitle: last == null
                  ? const Text('Hali kiritilmagan')
                  : Text(
                      '${vitalValueText(last)} ${t.unit}'
                      '${status != null ? ' • ${status.$1}' : ''}',
                      style: TextStyle(color: status?.$2),
                    ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => VitalDetailScreen(typeKey: t.key)),
              ),
            ),
          );
        },
      ),
    );
  }
}
