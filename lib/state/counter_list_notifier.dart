import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../storage/counter_file_storage.dart';

/// Owns all counter mutations and file-based auto-save with a 1-second debounce.
///
/// Initial state is provided at construction time (loaded from the most recent
/// file during app startup in `main()`). No SharedPreferences dependency.
class CounterListNotifier extends ChangeNotifier {
  final CounterFileStorage _fileStorage;
  CounterList _counters;

  // Current file tracking
  String? _currentFileName;
  String? _currentFilePath;
  DateTime? _lastSavedAt;
  bool _isSaving = false;

  // Auto-save debounce
  Timer? _autoSaveTimer;
  static const _autoSaveDelay = Duration(seconds: 1);

  CounterListNotifier({
    CounterFileStorage? fileStorage,
    CounterList? initialCounters,
    String? initialFileName,
    String? initialFilePath,
  })  : _fileStorage = fileStorage ?? CounterFileStorage(),
        _counters = initialCounters ?? CounterList.empty(CounterFactory()),
        _currentFileName = initialFileName,
        _currentFilePath = initialFilePath,
        _lastSavedAt = initialFilePath != null ? DateTime.now() : null;

  CounterList get counters => _counters;

  /// The raw file name, or `null` if no file is open.
  String? get currentFileName => _currentFileName;

  /// The file name without extension, for display in the title bar.
  String? get displayFileName {
    if (_currentFileName == null) return null;
    final name = _currentFileName!;
    final dot = name.lastIndexOf('.');
    return dot > 0 ? name.substring(0, dot) : name;
  }

  /// The path of the currently open file, or `null` if no file/web.
  String? get currentFilePath => _currentFilePath;

  /// When the file was last saved, or `null` if never saved.
  DateTime? get lastSavedAt => _lastSavedAt;

  /// Whether a debounced save is in progress.
  bool get isSaving => _isSaving;

  /// Whether no file is currently open (empty/welcome state).
  bool get hasNoFile => _currentFileName == null;

  /// Schedules a debounced auto-save to the current file (if one is open).
  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    if (_currentFilePath == null) return;

    _isSaving = true;
    notifyListeners();

    _autoSaveTimer = Timer(_autoSaveDelay, () async {
      if (_currentFilePath != null) {
        final success =
            await _fileStorage.saveToPath(_currentFilePath!, _counters);
        if (success) {
          _lastSavedAt = DateTime.now();
        }
      }
      _isSaving = false;
      notifyListeners();
    });
  }

  /// Replaces the current counter list (used for file import).
  void replaceCounters(CounterList newCounters) {
    _counters = newCounters;
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
    _isSaving = false;
    _autoSaveTimer?.cancel();
    notifyListeners();
  }

  /// Records that the file was just saved.
  void markSaved() {
    _lastSavedAt = DateTime.now();
    _isSaving = false;
    notifyListeners();
  }

  void add() {
    _counters.add();
    _scheduleAutoSave();
    notifyListeners();
  }

  void remove(int id) {
    _counters.remove(id);
    _scheduleAutoSave();
    notifyListeners();
  }

  void increment(int id) {
    _counters[id].increment();
    _scheduleAutoSave();
    notifyListeners();
  }

  void decrement(int id) {
    _counters[id].decrement();
    _scheduleAutoSave();
    notifyListeners();
  }

  void rename(int id, String newName) {
    _counters[id].rename(newName);
    _scheduleAutoSave();
    notifyListeners();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}
