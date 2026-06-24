import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'water_screen.dart';
import 'medication_screen.dart';
import 'weight_screen.dart';
import 'vitals_screen.dart';
import 'profile_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = <_MoreItem>[
      _MoreItem(Icons.water_drop, 'Suv', AppColors.water, const WaterScreen()),
      _MoreItem(Icons.medication, 'Dori-darmon', AppColors.med,
          const MedicationScreen()),
      _MoreItem(Icons.favorite, 'Sog\'liq ko\'rsatkichlari', AppColors.med,
          const VitalsScreen()),
      _MoreItem(Icons.monitor_weight, 'Vazn', AppColors.weight,
          const WeightScreen()),
      _MoreItem(Icons.person, 'Profil', AppColors.seed, const ProfileScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Yana')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tiles.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final t = tiles[i];
          return Card(
            child: ListTile(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              leading: CircleAvatar(
                backgroundColor: t.color.withValues(alpha: 0.15),
                child: Icon(t.icon, color: t.color),
              ),
              title: Text(t.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => t.page)),
            ),
          );
        },
      ),
    );
  }
}

class _MoreItem {
  final IconData icon;
  final String title;
  final Color color;
  final Widget page;
  _MoreItem(this.icon, this.title, this.color, this.page);
}
