import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/counter_list_notifier.dart';

class CountersPageMaterial extends StatefulWidget {
  const CountersPageMaterial({super.key, required this.title});

  final String title;

  @override
  State<CountersPageMaterial> createState() => _CountersPageMaterialState();
}

class _CountersPageMaterialState extends State<CountersPageMaterial> {
  void _renameCounter(int id, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Counter'),
        content: TextField(
          key: const Key('rename-field'),
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
          onSubmitted: (_) {
            context.read<CounterListNotifier>().rename(id, controller.text);
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
              context.read<CounterListNotifier>().rename(id, controller.text);
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
    final notifier = context.watch<CounterListNotifier>();

    if (notifier.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final counters = notifier.counters!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: counters.isEmpty
          ? const Center(child: Text('No counters yet. Tap + to add one.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: counters.counters.length,
                    itemBuilder: (context, index) {
                      final counter = counters.counters[index];
                      return Dismissible(
                        key: ValueKey(counter.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          color: Colors.red,
                          child: const Icon(Icons.delete_outline,
                              color: Colors.white),
                        ),
                        onDismissed: (_) =>
                            notifier.remove(counter.id),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: GestureDetector(
                              onTap: () => _renameCounter(
                                  counter.id, counter.name),
                              child: Text(counter.name),
                            ),
                            subtitle: Text(
                              '${counter.value}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  tooltip: 'Decrement',
                                  onPressed: () =>
                                      notifier.decrement(counter.id),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  tooltip: 'Increment',
                                  onPressed: () =>
                                      notifier.increment(counter.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Swipe left to delete',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: notifier.add,
        tooltip: 'Add Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
