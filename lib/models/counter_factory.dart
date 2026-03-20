import 'counter.dart';

class CounterFactory {
  int _nextId = 1;

  Counter create() => Counter(id: _nextId++);
}
