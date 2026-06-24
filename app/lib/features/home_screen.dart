import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_state.dart';
import '../data/step_tracker.dart';
import 'dashboard_screen.dart';
import 'nutrition_screen.dart';
import 'activity_screen.dart';
import 'sleep_screen.dart';
import 'more_screen.dart';

/// Pastki navigatsiya: Bosh sahifa, Ovqat, Faollik, Uyqu, Yana.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Avtomatik qadam sanashni ishga tushirish (real qurilmada).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StepTracker.start((steps) {
        final app = ref.read(appProvider.notifier);
        final today = DateTime.now();
        if (app.stepsOn(today) != steps) {
          app.setSteps(today, steps);
        }
      });
    });
  }

  void _openTab(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(onOpenTab: _openTab),
      const NutritionScreen(),
      const ActivityScreen(),
      const SleepScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _openTab,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Bosh'),
          NavigationDestination(
              icon: Icon(Icons.restaurant_outlined),
              selectedIcon: Icon(Icons.restaurant),
              label: 'Ovqat'),
          NavigationDestination(
              icon: Icon(Icons.directions_walk_outlined),
              selectedIcon: Icon(Icons.directions_walk),
              label: 'Faollik'),
          NavigationDestination(
              icon: Icon(Icons.bedtime_outlined),
              selectedIcon: Icon(Icons.bedtime),
              label: 'Uyqu'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Yana'),
        ],
      ),
    );
  }
}
