import 'package:flutter/material.dart';

import 'models/models.dart';

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
      home: CountersPage(
        title: 'Counters',
        counters: CounterList(CounterFactory()),
      ),
    );
  }
}

class CountersPage extends StatefulWidget {
  const CountersPage({super.key, required this.title, required this.counters});

  final String title;
  final CounterList counters;

  @override
  State<CountersPage> createState() => _CountersPageState();
}

class _CountersPageState extends State<CountersPage> {
  void _addCounter() {
    setState(() {
      widget.counters.add();
    });
  }

  void _removeCounter(int id) {
    setState(() {
      widget.counters.remove(id);
    });
  }

  void _renameCounter(int id) {
    final counter = widget.counters[id];
    final controller = TextEditingController(text: counter.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Counter'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
          onSubmitted: (_) {
            setState(() => counter.rename(controller.text));
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
              setState(() => counter.rename(controller.text));
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: widget.counters.isEmpty
          ? const Center(child: Text('No counters yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: widget.counters.counters.length,
              itemBuilder: (context, index) {
                final counter = widget.counters.counters[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () => _renameCounter(counter.id),
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
                              counter.decrement();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          tooltip: 'Increment',
                          onPressed: () {
                            setState(() {
                              counter.increment();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Delete counter',
                          onPressed: () => _removeCounter(counter.id),
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
