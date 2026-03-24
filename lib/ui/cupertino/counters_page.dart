import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show CircularProgressIndicator, Tooltip;
import 'package:counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../state/counter_list_notifier.dart';
import '../../state/locale_notifier.dart';
import '../../state/recent_files_notifier.dart';
import '../../storage/counter_file_storage.dart';
import '../saved_ago_text.dart';

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
  final _fileStorage = CounterFileStorage();

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

  void _showFileMenu() {
    final l10n = AppLocalizations.of(context)!;
    final notifier = context.read<CounterListNotifier>();
    final recentNotifier = context.read<RecentFilesNotifier>();
    final recentFiles = recentNotifier.files;
    final hasFile = !notifier.hasNoFile;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              _createNewFile();
            },
            child: Text(l10n.createNewFile),
          ),
          if (hasFile)
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                _saveAs();
              },
              child: Text(l10n.saveAs),
            ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              _openFromFile();
            },
            child: Text(l10n.openFromFile),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              _pickLanguage();
            },
            child: Text(l10n.language),
          ),
          if (!kIsWeb && recentFiles.isNotEmpty) ...[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                _showRecentFiles();
              },
              child: Text(l10n.recentFiles),
            ),
          ],
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  void _showRecentFiles() {
    final l10n = AppLocalizations.of(context)!;
    final recentNotifier = context.read<RecentFilesNotifier>();
    final recentFiles = recentNotifier.files;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.recentFiles),
        actions: [
          ...recentFiles.map((file) => CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openRecentFile(file.path, file.name);
                },
                child: Text(file.name),
              )),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              recentNotifier.clearRecent();
              Navigator.of(context).pop();
            },
            child: Text(l10n.clearRecents),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  Future<void> _createNewFile() async {
    final newList = CounterList(CounterFactory());
    final result = await _fileStorage.pickAndSave(newList);
    if (result == null || !mounted) return;

    final notifier = context.read<CounterListNotifier>();
    notifier.replaceCounters(newList);
    notifier.setCurrentFile(result.name, result.path);
    notifier.markSaved();

    if (result.path != null) {
      context.read<RecentFilesNotifier>().addRecent(result.path!, result.name);
    }
  }

  Future<void> _saveAs() async {
    final notifier = context.read<CounterListNotifier>();
    if (notifier.counters == null) return;

    final result = await _fileStorage.pickAndSave(notifier.counters!);
    if (result == null || !mounted) return;

    notifier.setCurrentFile(result.name, result.path);
    notifier.markSaved();

    if (result.path != null) {
      context.read<RecentFilesNotifier>().addRecent(result.path!, result.name);
    }
  }

  Future<void> _openFromFile() async {
    final result = await _fileStorage.pickAndLoad();
    if (result == null || !mounted) return;

    final notifier = context.read<CounterListNotifier>();
    notifier.replaceCounters(result.counters);
    notifier.setCurrentFile(result.name, result.path);
    notifier.markSaved();

    if (result.path != null) {
      context.read<RecentFilesNotifier>().addRecent(result.path!, result.name);
    }
  }

  Future<void> _openRecentFile(String path, String name) async {
    try {
      final result = await _fileStorage.pickAndLoad();
      if (result == null || !mounted) return;

      final notifier = context.read<CounterListNotifier>();
      notifier.replaceCounters(result.counters);
      notifier.setCurrentFile(result.name, result.path);
      notifier.markSaved();

      if (result.path != null) {
        context
            .read<RecentFilesNotifier>()
            .addRecent(result.path!, result.name);
      }
    } catch (_) {
      if (mounted) {
        context.read<RecentFilesNotifier>().removeRecent(path);
      }
    }
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.doc_text,
              size: 64,
              color: CupertinoColors.secondaryLabel,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.emptyStateTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyStateMessage,
              style: const TextStyle(
                fontSize: 15,
                color: CupertinoColors.secondaryLabel,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              onPressed: _createNewFile,
              child: Text(l10n.createNewFile),
            ),
            const SizedBox(height: 12),
            CupertinoButton(
              onPressed: _openFromFile,
              child: Text(l10n.openFromFile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountersList(
      AppLocalizations l10n, CounterListNotifier notifier) {
    final counters = notifier.counters!;
    return Column(
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
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: CupertinoColors.destructiveRed,
                  child: const Icon(CupertinoIcons.delete,
                      color: CupertinoColors.white),
                ),
                onDismissed: (_) => notifier.remove(counter.id),
                child: ColoredBox(
                  color: CupertinoColors.systemBackground
                      .resolveFrom(context),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
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
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        counter.name,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      CupertinoIcons.pencil,
                                      size: 14,
                                      color: CupertinoColors.secondaryLabel,
                                    ),
                                  ],
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
                            onPressed: counter.value > 0
                                ? () => notifier.decrement(counter.id)
                                : null,
                            child: const Icon(CupertinoIcons.minus),
                          ),
                        ),
                        Tooltip(
                          message: l10n.increment,
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
        if (counters.counters.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
            child: Text(
              l10n.swipeToDelete,
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
      ],
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

    final hasFile = !notifier.hasNoFile;
    final hasCounters = !notifier.counters!.isEmpty;
    final showCounters = hasFile || hasCounters;
    final titleText = notifier.displayFileName ?? l10n.appTitle;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(titleText, style: const TextStyle(fontSize: 17)),
            if (hasFile)
              SavedAgoText(
                lastSavedAt: notifier.lastSavedAt,
                isSaving: notifier.isSaving,
                style: const TextStyle(
                  fontSize: 11,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
          ],
        ),
        trailing: Tooltip(
          message: 'Menu',
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _showFileMenu,
            child: const Icon(CupertinoIcons.ellipsis_circle),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: showCounters
            ? _buildCountersList(l10n, notifier)
            : _buildEmptyState(l10n),
      ),
    );
  }
}
