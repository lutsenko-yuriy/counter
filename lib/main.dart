import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Counters'),
    );
  }
}

class CounterData {
  String name;
  int value;

  CounterData({required this.name, this.value = 0});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<CounterData> _counters = [CounterData(name: 'Counter 1')];
  int _nextNumber = 2;

  void _addCounter() {
    setState(() {
      _counters.add(CounterData(name: 'Counter $_nextNumber'));
      _nextNumber++;
    });
  }

  void _removeCounter(int index) {
    setState(() {
      _counters.removeAt(index);
    });
  }

  void _renameCounter(int index) {
    final controller = TextEditingController(text: _counters[index].name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Counter'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
          onSubmitted: (_) {
            _applyRename(index, controller.text);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _applyRename(index, controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _applyRename(int index, String newName) {
    final trimmed = newName.trim();
    if (trimmed.isNotEmpty) {
      setState(() {
        _counters[index].name = trimmed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _counters.isEmpty
          ? const Center(child: Text('No counters yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: _counters.length,
              itemBuilder: (context, index) {
                final counter = _counters[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () => _renameCounter(index),
                      child: Text(counter.name),
                    ),
                    subtitle: Text(
                      '${counter.value}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          tooltip: 'Decrement',
                          onPressed: () {
                            setState(() {
                              if (counter.value > 0) counter.value--;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          tooltip: 'Increment',
                          onPressed: () {
                            setState(() {
                              counter.value++;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Delete counter',
                          onPressed: () => _removeCounter(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCounter,
        tooltip: 'Add Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
