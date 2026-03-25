import 'counter.dart';
import 'counter_factory.dart';

class CounterList {
  final CounterFactory _factory;
  final List<Counter> _counters;

  CounterList(this._factory) : _counters = [_factory.create()];

  CounterList.empty(this._factory) : _counters = [];

  CounterList.restore(this._factory, List<Counter> counters)
      : _counters = List.of(counters);

  List<Counter> get counters => List.unmodifiable(_counters);
  bool get isEmpty => _counters.isEmpty;

  Counter operator [](int id) => _counters.firstWhere((c) => c.id == id);

  void add() {
    _counters.add(_factory.create());
  }

  void remove(int id) {
    _counters.removeWhere((c) => c.id == id);
  }
}
