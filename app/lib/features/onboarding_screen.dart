import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../data/app_state.dart';
import '../data/db.dart';
import '../data/profile.dart';
import 'home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pc = PageController();
  int _page = 0;

  final _name = TextEditingController();
  final _age = TextEditingController(text: '25');
  final _height = TextEditingController(text: '175');
  final _weight = TextEditingController(text: '70');
  String _gender = 'male';

  @override
  void dispose() {
    _pc.dispose();
    _name.dispose();
    _age.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  void _finish() {
    final app = ref.read(appProvider.notifier);
    final w = double.tryParse(_weight.text.trim().replaceAll(',', '.')) ?? 70;
    final p = Profile.def().copyWith(
      name: _name.text.trim().isEmpty ? 'Foydalanuvchi' : _name.text.trim(),
      gender: _gender,
      age: int.tryParse(_age.text.trim()) ?? 25,
      heightCm: double.tryParse(_height.text.trim()) ?? 175,
      weightKg: w,
    );
    app.saveProfile(p);
    app.addWeight(w);
    Db.settings.put('onboarding_done', true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pc,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _intro(
                    Icons.favorite,
                    AppColors.med,
                    'Salomatligingiz nazoratda',
                    'Ovqatlanish, suv, yurish, uyqu, vazn va dori-darmonni '
                        'bir ilovada kuzating.',
                  ),
                  _intro(
                    Icons.insights,
                    AppColors.activity,
                    'Tahlil va grafiklar',
                    'Kunlik va haftalik dinamikani ko\'ring, maqsadlaringizga '
                        'erishing.',
                  ),
                  _setupPage(scheme),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  width: _page == i ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == i
                        ? scheme.primary
                        : scheme.primary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_page < 2) {
                      _pc.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    } else {
                      _finish();
                    }
                  },
                  child: Text(_page < 2 ? 'Davom etish' : 'Boshlash'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _intro(IconData icon, Color color, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 72, color: color),
          ),
          const SizedBox(height: 32),
          Text(title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(desc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _setupPage(ColorScheme scheme) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 8),
        Text('Oz ma\'lumot',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Bu kunlik kaloriya me\'yorini hisoblash uchun kerak.'),
        const SizedBox(height: 20),
        TextField(
          controller: _name,
          decoration: const InputDecoration(labelText: 'Ism'),
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
            Expanded(
              child: TextField(
                controller: _age,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Yosh'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _height,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Bo\'y (sm)'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _weight,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Vazn (kg)'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
