import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'data/db.dart';
import 'data/notifications.dart';
import 'data/settings.dart';
import 'features/home_screen.dart';
import 'features/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Db.init();
  await Notifications.init();
  await Notifications.requestPermissions();
  runApp(const ProviderScope(child: HealthApp()));
}

class HealthApp extends ConsumerWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp(
      title: 'Salomatlik',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: Db.settings.get('onboarding_done') == true
          ? const HomeScreen()
          : const OnboardingScreen(),
    );
  }
}
