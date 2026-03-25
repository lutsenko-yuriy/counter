import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show Tooltip;
import 'package:counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../state/counter_list_notifier.dart';
import '../../state/locale_notifier.dart';
import '../../state/recent_files_notifier.dart';
import '../../storage/counter_file_storage.dart';
import '../app_colors.dart';
import '../app_fonts.dart';
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
  const CountersPageCupertino({super.key, this.staleFilePaths = const []});

  final List<String> staleFilePaths;

  @override
  State<CountersPageCupertino> createState() => _CountersPageCupertinoState();
}

class _CountersPageCupertinoState extends State<CountersPageCupertino> {
  final _fileStorage = CounterFileStorage();

  @override
  void initState() {
    super.initState();
    if (widget.staleFilePaths.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showStaleFileErrors();
      });
    }
  }

  void _showStaleFileErrors() {
    final l10n = AppLocalizations.of(context)!;
    for (final path in widget.staleFilePaths) {
      final name = path.split('/').last.split('\\').last;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(l10n.fileNotFound(name)),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      );
    }
  }

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

    final result = await _fileStorage.pickAndSave(notifier.counters);
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
      final counters = await _fileStorage.loadFromPath(path);
      if (!mounted) return;

      final notifier = context.read<CounterListNotifier>();
      notifier.replaceCounters(counters);
      notifier.setCurrentFile(name, path);
      notifier.markSaved();

      context.read<RecentFilesNotifier>().addRecent(path, name);
    } catch (_) {
      if (mounted) {
        context.read<RecentFilesNotifier>().removeRecent(path);
      }
    }
  }

  Widget _buildEmptyState(
      AppLocalizations l10n, RecentFilesNotifier recentNotifier) {
    final recentFiles = recentNotifier.files;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.doc_text,
              size: 64,
              color: AppColors.steel,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.emptyStateTitle,
              style: AppFonts.logoStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyStateMessage,
              style: AppFonts.logoStyle(
                fontSize: 15,
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              onPressed: _createNewFile,
              child: Text(l10n.createNewFile,
                  style: const TextStyle(color: AppColors.cream)),
            ),
            const SizedBox(height: 12),
            CupertinoButton(
              onPressed: _openFromFile,
              child: Text(l10n.openFromFile,
                  style: const TextStyle(color: AppColors.textMuted)),
            ),
            if (!kIsWeb && recentFiles.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text(
                l10n.recentFiles,
                style: AppFonts.logoStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              ...recentFiles.map((file) => SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      onPressed: () => _openRecentFile(file.path, file.name),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(CupertinoIcons.doc,
                              size: 18, color: AppColors.textMuted),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              file.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.textMuted),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCountersList(
      AppLocalizations l10n, CounterListNotifier notifier) {
    final counters = notifier.counters;
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
                    color: AppColors.cream,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                        children: [
                          const Icon(CupertinoIcons.plus,
                              color: AppColors.steel),
                          const SizedBox(height: 8),
                          Text(
                            l10n.tapToAddCounter,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              color: AppColors.steel,
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
                  color: AppColors.cardCream,
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
                                        style: AppFonts.logoStyle(
                                          fontSize: 17,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      CupertinoIcons.pencil,
                                      size: 14,
                                      color: AppColors.steel,
                                    ),
                                  ],
                                ),
                                Text(
                                  '${counter.value}',
                                  style: AppFonts.typewriterStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
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
                            child: Icon(CupertinoIcons.minus,
                                color: counter.value > 0
                                    ? AppColors.darkSteel
                                    : AppColors.steel.withAlpha(60)),
                          ),
                        ),
                        Tooltip(
                          message: l10n.increment,
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            onPressed: () =>
                                notifier.increment(counter.id),
                            child: const Icon(CupertinoIcons.plus,
                                color: AppColors.darkSteel),
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
              style: AppFonts.logoStyle(
                fontSize: 13,
                color: AppColors.steel,
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
    final recentNotifier = context.watch<RecentFilesNotifier>();

    final hasFile = !notifier.hasNoFile;
    final hasCounters = !notifier.counters.isEmpty;
    final showCounters = hasFile || hasCounters;
    final titleText = notifier.displayFileName ?? l10n.appTitle;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(titleText, style: AppFonts.typewriterStyle(fontSize: 17)),
            if (hasFile)
              SavedAgoText(
                lastSavedAt: notifier.lastSavedAt,
                isSaving: notifier.isSaving,
                style: AppFonts.typewriterStyle(
                  fontSize: 11,
                  color: AppColors.textPrimary,
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
            : _buildEmptyState(l10n, recentNotifier),
      ),
    );
  }
}
