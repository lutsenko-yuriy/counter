class CounterData {
  String name;
  int value;

  CounterData({required this.name, this.value = 0});

  void increment() {
    value++;
  }

  void decrement() {
    if (value > 0) value--;
  }
}
