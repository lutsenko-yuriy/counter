class Counter {
  final int id;
  String name;
  int value;

  Counter({required this.id, this.value = 0}) : name = 'Counter $id';

  void rename(String newName) {
    final trimmed = newName.trim();
    if (trimmed.isNotEmpty) name = trimmed;
  }

  void increment() {
    value++;
  }

  void decrement() {
    if (value > 0) value--;
  }
}
