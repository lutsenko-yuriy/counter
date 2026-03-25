import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import 'counter_json.dart';

class CounterStorage {
  static const _key = 'counters';

  Future<CounterList?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;

    final data = jsonDecode(json) as Map<String, dynamic>;
    return counterListFromJson(data);
  }

  Future<void> save(CounterList counters) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(counterListToJson(counters)));
  }
}
