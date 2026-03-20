import 'counter.dart';

class CounterFactory {
  int _nextId;

  CounterFactory({int initialNextId = 1}) : _nextId = initialNextId;

  int get nextId => _nextId;

  Counter create() => Counter(id: _nextId++);
}
