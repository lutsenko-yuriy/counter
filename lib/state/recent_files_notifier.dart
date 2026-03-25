import 'package:flutter/foundation.dart';

import '../models/recent_file.dart';
import '../storage/recent_files_storage.dart';

/// Manages the list of recently opened/saved counter files.
///
/// Caps the list at [maxRecent] entries. Most recently used file is first.
class RecentFilesNotifier extends ChangeNotifier {
  static const maxRecent = 10;

  final RecentFilesStorage _storage;
  List<RecentFile> _files = [];

  RecentFilesNotifier(this._storage) {
    _load();
  }

  List<RecentFile> get files => List.unmodifiable(_files);

  Future<void> _load() async {
    _files = await _storage.load();
    notifyListeners();
  }

  /// Adds or moves a file to the front of the recent list.
  void addRecent(String path, String name) {
    _files.removeWhere((f) => f.path == path);
    _files.insert(0, RecentFile(
      path: path,
      name: name,
      lastOpened: DateTime.now(),
    ));
    if (_files.length > maxRecent) {
      _files = _files.sublist(0, maxRecent);
    }
    _storage.save(_files);
    notifyListeners();
  }

  /// Removes a specific file from the recent list.
  void removeRecent(String path) {
    _files.removeWhere((f) => f.path == path);
    _storage.save(_files);
    notifyListeners();
  }

  /// Clears the entire recent files list.
  void clearRecent() {
    _files.clear();
    _storage.save(_files);
    notifyListeners();
  }
}
