import 'counter_data.dart';

class CounterListModel {
  final List<CounterData> _counters = [CounterData(name: 'Counter 1')];
  int _nextNumber = 2;

  List<CounterData> get counters => List.unmodifiable(_counters);
  bool get isEmpty => _counters.isEmpty;
  int get length => _counters.length;

  CounterData operator [](int index) => _counters[index];

  void add() {
    _counters.add(CounterData(name: 'Counter $_nextNumber'));
    _nextNumber++;
  }

  void removeAt(int index) {
    _counters.removeAt(index);
  }

  void rename(int index, String newName) {
    final trimmed = newName.trim();
    if (trimmed.isNotEmpty) {
      _counters[index].name = trimmed;
    }
  }
}
