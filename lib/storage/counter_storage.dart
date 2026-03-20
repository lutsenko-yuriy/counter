import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

class CounterStorage {
  static const _key = 'counters';

  Future<CounterList?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;

    final data = jsonDecode(json) as Map<String, dynamic>;
    final counters = (data['counters'] as List)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => Counter(id: e['id'] as int, value: e['value'] as int)
          ..rename(e['name'] as String))
        .toList();
    final nextId =
        counters.isEmpty ? 1 : counters.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
    return CounterList.restore(CounterFactory(initialNextId: nextId), counters);
  }

  Future<void> save(CounterList counters) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'counters': counters.counters
          .map((c) => {'id': c.id, 'name': c.name, 'value': c.value})
          .toList(),
    };
    await prefs.setString(_key, jsonEncode(data));
  }
}
