import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Tooltip, CircularProgressIndicator;
import 'package:provider/provider.dart';

import '../../state/counter_list_notifier.dart';

class CountersPageCupertino extends StatefulWidget {
  const CountersPageCupertino({super.key, required this.title});

  final String title;

  @override
  State<CountersPageCupertino> createState() => _CountersPageCupertinoState();
}

class _CountersPageCupertinoState extends State<CountersPageCupertino> {
  void _renameCounter(int id, String currentName) {
    final controller = TextEditingController(text: currentName);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Rename Counter'),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CupertinoTextField(
            key: const Key('rename-field'),
            controller: controller,
            autofocus: true,
            onSubmitted: (_) {
              context.read<CounterListNotifier>().rename(id, controller.text);
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
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
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final counters = notifier.counters!;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
        trailing: Tooltip(
          message: 'Add Counter',
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: notifier.add,
            child: const Icon(CupertinoIcons.add),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: counters.isEmpty
            ? const Center(child: Text('No counters yet. Tap + to add one.'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: counters.counters.length,
                      separatorBuilder: (_, __) => Container(
                        height: 0.5,
                        margin: const EdgeInsets.only(left: 16),
                        color: CupertinoColors.separator,
                      ),
                      itemBuilder: (context, index) {
                        final counter = counters.counters[index];
                        return Dismissible(
                          key: ValueKey(counter.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24),
                            color: CupertinoColors.destructiveRed,
                            child: const Icon(CupertinoIcons.delete,
                                color: CupertinoColors.white),
                          ),
                          onDismissed: (_) => notifier.remove(counter.id),
                          child: ColoredBox(
                            color: CupertinoColors.systemBackground
                                .resolveFrom(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _renameCounter(
                                          counter.id, counter.name),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            counter.name,
                                            style: const TextStyle(
                                                fontSize: 17),
                                          ),
                                          Text(
                                            '${counter.value}',
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    message: 'Decrement',
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      onPressed: () =>
                                          notifier.decrement(counter.id),
                                      child:
                                          const Icon(CupertinoIcons.minus),
                                    ),
                                  ),
                                  Tooltip(
                                    message: 'Increment',
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      onPressed: () =>
                                          notifier.increment(counter.id),
                                      child: const Icon(CupertinoIcons.plus),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Swipe left to delete',
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
