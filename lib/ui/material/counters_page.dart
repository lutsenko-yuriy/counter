import 'package:flutter/material.dart';
import 'package:counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../state/counter_list_notifier.dart';
import '../../state/locale_notifier.dart';

const _supportedLocales = [
  (Locale('en'), 'English'),
  (Locale('de'), 'Deutsch'),
  (Locale('fr'), 'Français'),
  (Locale('ru'), 'Русский'),
  (Locale('ar'), 'العربية'),
  (Locale('zh'), '中文'),
  (Locale('ja'), '日本語'),
];

class CountersPageMaterial extends StatefulWidget {
  const CountersPageMaterial({super.key});

  @override
  State<CountersPageMaterial> createState() => _CountersPageMaterialState();
}

class _CountersPageMaterialState extends State<CountersPageMaterial> {
  void _renameCounter(int id, String currentName) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.renameCounter),
        content: TextField(
          key: const Key('rename-field'),
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.nameLabel),
          onSubmitted: (_) {
            context.read<CounterListNotifier>().rename(id, controller.text);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<CounterListNotifier>().rename(id, controller.text);
              Navigator.of(context).pop();
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _pickLanguage() {
    final current = context.read<LocaleNotifier>().locale;
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: _supportedLocales.map((entry) {
          final (locale, name) = entry;
          return SimpleDialogOption(
            onPressed: () {
              context.read<LocaleNotifier>().setLocale(locale);
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                if (locale == current)
                  const Icon(Icons.check, size: 18)
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(name),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = context.watch<CounterListNotifier>();

    if (notifier.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final counters = notifier.counters!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.pageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Language',
            onPressed: _pickLanguage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: counters.counters.length + 1,
              itemBuilder: (context, index) {
                if (index == counters.counters.length) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: InkWell(
                      onTap: notifier.add,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: Column(
                          children: [
                            Icon(Icons.add,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(height: 8),
                            Text(
                              l10n.tapToAddCounter,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
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
                  onDismissed: (_) => notifier.remove(counter.id),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(
                          16, 0, 8, 0),
                      title: GestureDetector(
                        onTap: () =>
                            _renameCounter(counter.id, counter.name),
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
                            tooltip: l10n.decrement,
                            onPressed: counter.value > 0
                                ? () => notifier.decrement(counter.id)
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            tooltip: l10n.increment,
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
          if (counters.counters.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
              child: Text(
                l10n.swipeToDelete,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
