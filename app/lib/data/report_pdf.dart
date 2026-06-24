import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/util.dart';
import 'app_state.dart';
import 'vital_types.dart';

/// Salomatlik hisobotini PDF qilib yaratadi va ulashadi.
class HealthReport {
  static Future<void> generateAndShare(AppNotifier app) async {
    final doc = pw.Document();
    final p = app.profile;
    final now = DateTime.now();

    final cal = app.caloriesOn(now);
    final water = app.waterOn(now);
    final steps = app.stepsOn(now);
    final sleep = app.sleepFor(now);
    final weight = app.latestWeight ?? p.weightKg;
    final bmiVal = bmi(weight, p.heightCm);

    final vitalRows = <List<String>>[];
    for (final t in kVitalTypes) {
      final v = app.latestVital(t.key);
      if (v == null) continue;
      final value = t.isMood
          ? kMoodLabels[v.v1.round().clamp(0, 4)]
          : '${vitalValueText(v)} ${t.unit}';
      vitalRows.add([t.label, value, '${v.date.day}.${v.date.month}.${v.date.year}']);
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, text: 'Salomatlik hisoboti'),
          pw.Text('Sana: ${now.day}.${now.month}.${now.year}'),
          pw.SizedBox(height: 16),

          pw.Text('Profil',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.Bullet(text: 'Ism: ${p.name}'),
          pw.Bullet(
              text: 'Jins: ${p.gender == 'male' ? 'Erkak' : 'Ayol'}, '
                  'Yosh: ${p.age}'),
          pw.Bullet(
              text: 'Bo\'y: ${p.heightCm.round()} sm, '
                  'Vazn: ${weight.toStringAsFixed(1)} kg'),
          pw.Bullet(
              text: 'TVI (BMI): ${bmiVal.toStringAsFixed(1)} '
                  '(${bmiLabel(bmiVal)})'),
          pw.SizedBox(height: 16),

          pw.Text('Bugungi ko\'rsatkichlar',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: ['Ko\'rsatkich', 'Qiymat', 'Maqsad'],
            data: [
              ['Kaloriya', '${cal.round()} kkal', '${app.calorieGoal.round()} kkal'],
              ['Suv', '$water ml', '${p.waterGoalMl} ml'],
              ['Qadamlar', '$steps', '${p.stepGoal}'],
              [
                'Uyqu',
                sleep == null ? '—' : '${sleep.hours.toStringAsFixed(1)} soat',
                '${p.sleepGoalH.toStringAsFixed(0)} soat'
              ],
            ],
          ),
          pw.SizedBox(height: 16),

          if (vitalRows.isNotEmpty) ...[
            pw.Text('So\'nggi sog\'liq ko\'rsatkichlari',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.TableHelper.fromTextArray(
              headers: ['Ko\'rsatkich', 'Qiymat', 'Sana'],
              data: vitalRows,
            ),
            pw.SizedBox(height: 16),
          ],

          pw.Divider(),
          pw.Text(
            'Eslatma: ushbu hisobot shaxsiy kuzatuv natijasidir va tibbiy '
            'tashxis yoki maslahat o\'rnini bosmaydi.',
            style: pw.TextStyle(
                fontSize: 10, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'salomatlik_hisobot.pdf',
    );
  }
}
