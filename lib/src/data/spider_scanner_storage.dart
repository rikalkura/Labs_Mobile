import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/spider_scanner.dart';

class SpiderScannerStorage {
  static const _key = 'spider_scanners';

  Future<List<SpiderScanner>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => SpiderScanner.fromJson(jsonDecode(e))).toList();
  }

  Future<void> saveAll(List<SpiderScanner> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = list.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  Future<void> add(SpiderScanner scanner) async {
    final list = await getAll();
    list.add(scanner);
    await saveAll(list);
  }

  Future<void> update(SpiderScanner updated) async {
    final list = await getAll();
    final index = list.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      list[index] = updated;
      await saveAll(list);
    }
  }

  Future<void> delete(String id) async {
    final list = await getAll();
    list.removeWhere((s) => s.id == id);
    await saveAll(list);
  }
}
