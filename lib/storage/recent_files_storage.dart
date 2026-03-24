import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/recent_file.dart';

/// Persists the recent files list in [SharedPreferences].
class RecentFilesStorage {
  static const _key = 'recent_files';

  Future<List<RecentFile>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return [];

    final list = jsonDecode(json) as List;
    return list
        .map((e) => e as Map<String, dynamic>)
        .map((e) => RecentFile(
              path: e['path'] as String,
              name: e['name'] as String,
              lastOpened: DateTime.parse(e['lastOpened'] as String),
            ))
        .toList();
  }

  Future<void> save(List<RecentFile> files) async {
    final prefs = await SharedPreferences.getInstance();
    final list = files
        .map((f) => {
              'path': f.path,
              'name': f.name,
              'lastOpened': f.lastOpened.toIso8601String(),
            })
        .toList();
    await prefs.setString(_key, jsonEncode(list));
  }
}
