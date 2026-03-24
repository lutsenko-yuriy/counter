import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../storage/counter_file_storage.dart';
import '../storage/counter_storage.dart';

/// Owns all counter mutations, persistence to SharedPreferences,
/// and file-based auto-save with a 1-second debounce.
class CounterListNotifier extends ChangeNotifier {
  final CounterStorage _storage;
  final CounterFileStorage _fileStorage;
  CounterList? _counters;

  // Current file tracking
  String? _currentFileName;
  String? _currentFilePath;
  DateTime? _lastSavedAt;

  // Auto-save debounce
  Timer? _autoSaveTimer;
  static const _autoSaveDelay = Duration(seconds: 1);

  CounterListNotifier(this._storage, {CounterFileStorage? fileStorage})
      : _fileStorage = fileStorage ?? CounterFileStorage() {
    _load();
  }

  CounterList? get counters => _counters;
  bool get isLoading => _counters == null;

  /// The name of the currently open file, or `null` if untitled.
  String? get currentFileName => _currentFileName;

  /// The path of the currently open file, or `null` if untitled/web.
  String? get currentFilePath => _currentFilePath;

  /// When the file was last saved, or `null` if never saved.
  DateTime? get lastSavedAt => _lastSavedAt;

  Future<void> _load() async {
    _counters = await _storage.load() ?? CounterList(CounterFactory());
    notifyListeners();
  }

  Future<void> _save() async {
    await _storage.save(_counters!);
    _scheduleAutoSave();
  }

  /// Schedules a debounced auto-save to the current file (if one is open).
  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    if (_currentFilePath == null) return;

    _autoSaveTimer = Timer(_autoSaveDelay, () async {
      if (_currentFilePath != null && _counters != null) {
        final success =
            await _fileStorage.saveToPath(_currentFilePath!, _counters!);
        if (success) {
          _lastSavedAt = DateTime.now();
          notifyListeners();
        }
      }
    });
  }

  /// Replaces the current counter list (used for file import).
  void replaceCounters(CounterList newCounters) {
    _counters = newCounters;
    _storage.save(newCounters);
    notifyListeners();
  }

  /// Sets the current file name and path.
  void setCurrentFile(String name, String? path) {
    _currentFileName = name;
    _currentFilePath = path;
    notifyListeners();
  }

  /// Clears the current file association.
  void clearCurrentFile() {
    _currentFileName = null;
    _currentFilePath = null;
    _lastSavedAt = null;
    _autoSaveTimer?.cancel();
    notifyListeners();
  }

  /// Records that the file was just saved.
  void markSaved() {
    _lastSavedAt = DateTime.now();
    notifyListeners();
  }

  void add() {
    _counters!.add();
    _save();
    notifyListeners();
  }

  void remove(int id) {
    _counters!.remove(id);
    _save();
    notifyListeners();
  }

  void increment(int id) {
    _counters![id].increment();
    _save();
    notifyListeners();
  }

  void decrement(int id) {
    _counters![id].decrement();
    _save();
    notifyListeners();
  }

  void rename(int id, String newName) {
    _counters![id].rename(newName);
    _save();
    notifyListeners();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}
