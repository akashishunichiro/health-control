import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'db.dart';

/// Barcha ma'lumotlarni JSON faylga eksport / import qilish (lokal zaxira).
class Backup {
  static Map<String, dynamic> _dump(Box box) {
    final out = <String, dynamic>{};
    for (final k in box.keys) {
      out[k.toString()] = box.get(k);
    }
    return out;
  }

  static String _serialize() {
    final data = {
      'version': 1,
      'meals': _dump(Db.meals),
      'water': _dump(Db.water),
      'sleep': _dump(Db.sleep),
      'steps': _dump(Db.steps),
      'weight': _dump(Db.weight),
      'medications': _dump(Db.medications),
      'med_intakes': _dump(Db.medIntakes),
      'vitals': _dump(Db.vitals),
      'settings': _dump(Db.settings),
    };
    return jsonEncode(data);
  }

  static Future<void> exportData() async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/salomatlik_zaxira.json');
    await file.writeAsString(_serialize());
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Salomatlik ilovasi zaxira nusxasi',
      ),
    );
  }

  static Future<bool> importData() async {
    const group = XTypeGroup(label: 'JSON', extensions: ['json']);
    final picked = await openFile(acceptedTypeGroups: [group]);
    if (picked == null) return false;
    final content = await picked.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;

    await _restore(Db.meals, data['meals']);
    await _restore(Db.water, data['water']);
    await _restore(Db.sleep, data['sleep']);
    await _restore(Db.steps, data['steps']);
    await _restore(Db.weight, data['weight']);
    await _restore(Db.medications, data['medications']);
    await _restore(Db.medIntakes, data['med_intakes']);
    await _restore(Db.vitals, data['vitals']);
    await _restore(Db.settings, data['settings']);
    return true;
  }

  static Future<void> _restore(Box box, dynamic map) async {
    if (map is! Map) return;
    await box.clear();
    for (final e in map.entries) {
      await box.put(e.key.toString(), e.value);
    }
  }
}
