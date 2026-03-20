import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../storage/counter_storage.dart';

class CounterListNotifier extends ChangeNotifier {
  final CounterStorage _storage;
  CounterList? _counters;

  CounterListNotifier(this._storage) {
    _load();
  }

  CounterList? get counters => _counters;
  bool get isLoading => _counters == null;

  Future<void> _load() async {
    _counters = await _storage.load() ?? CounterList(CounterFactory());
    notifyListeners();
  }

  Future<void> _save() => _storage.save(_counters!);

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
}
