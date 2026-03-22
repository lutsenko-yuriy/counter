import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show CircularProgressIndicator, Tooltip;
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

class CountersPageCupertino extends StatefulWidget {
  const CountersPageCupertino({super.key});

  @override
  State<CountersPageCupertino> createState() => _CountersPageCupertinoState();
}

class _CountersPageCupertinoState extends State<CountersPageCupertino> {
  void _renameCounter(int id, String currentName) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentName);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.renameCounter),
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
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
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
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: _supportedLocales.map((entry) {
          final (locale, name) = entry;
          return CupertinoActionSheetAction(
            isDefaultAction: locale == current,
            onPressed: () {
              context.read<LocaleNotifier>().setLocale(locale);
              Navigator.of(context).pop();
            },
            child: Text(name),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        middle: Text(l10n.pageTitle),
        trailing: Tooltip(
          message: 'Language',
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _pickLanguage,
            child: const Icon(CupertinoIcons.globe),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: counters.counters.length + 1,
                separatorBuilder: (_, __) => Container(
                  height: 0.5,
                  color: CupertinoColors.separator,
                ),
                itemBuilder: (context, index) {
                  if (index == counters.counters.length) {
                    return GestureDetector(
                      onTap: notifier.add,
                      child: ColoredBox(
                        color: CupertinoColors.systemBackground
                            .resolveFrom(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Column(
                            children: [
                              const Icon(CupertinoIcons.plus,
                                  color: CupertinoColors.activeBlue),
                              const SizedBox(height: 8),
                              Text(
                                l10n.tapToAddCounter,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: CupertinoColors.activeBlue,
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
                      color: CupertinoColors.destructiveRed,
                      child: const Icon(CupertinoIcons.delete,
                          color: CupertinoColors.white),
                    ),
                    onDismissed: (_) => notifier.remove(counter.id),
                    child: ColoredBox(
                      color: CupertinoColors.systemBackground
                          .resolveFrom(context),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16, 12, 8, 12),
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
                                      style:
                                          const TextStyle(fontSize: 17),
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
                              message: l10n.decrement,
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
                              message: l10n.increment,
                              child: CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                onPressed: () =>
                                    notifier.increment(counter.id),
                                child:
                                    const Icon(CupertinoIcons.plus),
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
            if (counters.counters.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.swipeToDelete,
                  style: const TextStyle(
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
