import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../data/app_state.dart';
import 'add_medication_screen.dart';

class MedicationScreen extends ConsumerWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appProvider);
    final app = ref.read(appProvider.notifier);
    final today = DateTime.now();
    final meds = app.medications;

    return Scaffold(
      appBar: AppBar(title: const Text('Dori-darmon')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddMedicationScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Dori'),
      ),
      body: meds.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Dori qo\'shilmagan.\n"+ Dori" tugmasi orqali qo\'shing.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              children: meds
                  .map((m) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0x22E0556E),
                                    child: Icon(Icons.medication,
                                        color: AppColors.med),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(m.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        if (m.dose.isNotEmpty)
                                          Text(m.dose,
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () =>
                                        app.deleteMedication(m.id),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: m.times.map((t) {
                                  final taken = app.isTaken(m.id, today, t);
                                  return FilterChip(
                                    label: Text(t),
                                    selected: taken,
                                    avatar: Icon(
                                      taken
                                          ? Icons.check_circle
                                          : Icons.schedule,
                                      color: taken
                                          ? AppColors.activity
                                          : null,
                                    ),
                                    onSelected: (_) =>
                                        app.toggleTaken(m.id, today, t),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
