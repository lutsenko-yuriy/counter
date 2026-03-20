import 'package:flutter/material.dart';

import 'counter_list_model.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _model = CounterListModel();

  void _addCounter() {
    setState(() {
      _model.add();
    });
  }

  void _removeCounter(int index) {
    setState(() {
      _model.removeAt(index);
    });
  }

  void _renameCounter(int index) {
    final controller = TextEditingController(text: _model[index].name);
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
    setState(() {
      _model.rename(index, newName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _model.isEmpty
          ? const Center(child: Text('No counters yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: _model.length,
              itemBuilder: (context, index) {
                final counter = _model[index];
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
