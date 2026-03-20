class Counter {
  final int id;
  String name;
  int value;

  Counter({required this.id, this.value = 0}) : name = 'Counter $id';

  Counter._restore({required this.id, required this.name, required this.value});

  factory Counter.fromJson(Map<String, dynamic> json) => Counter._restore(
        id: json['id'] as int,
        name: json['name'] as String,
        value: json['value'] as int,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'value': value};

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
