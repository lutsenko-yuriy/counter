import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../state/counter_list_notifier.dart';
import '../../state/locale_notifier.dart';
import '../../state/recent_files_notifier.dart';
import '../../storage/counter_file_storage.dart';
import '../saved_ago_text.dart';

const _supportedLocales = [
  (Locale('en'), '🇬🇧', 'English'),
  (Locale('de'), '🇩🇪', 'Deutsch'),
  (Locale('fr'), '🇫🇷', 'Français'),
  (Locale('ru'), '🇷🇺', 'Русский'),
  (Locale('ar'), '🇸🇦', 'العربية'),
  (Locale('zh'), '🇨🇳', '中文'),
  (Locale('ja'), '🇯🇵', '日本語'),
];

class CountersPageMaterial extends StatefulWidget {
  const CountersPageMaterial({super.key, this.staleFilePaths = const []});

  final List<String> staleFilePaths;

  @override
  State<CountersPageMaterial> createState() => _CountersPageMaterialState();
}

class _CountersPageMaterialState extends State<CountersPageMaterial> {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fileNotFound(name))),
      );
    }
  }

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
          final (locale, flag, name) = entry;
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
                Text(flag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(name),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Creates a brand new file with an empty counter list.
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

  /// Saves the current list to a new file (Save As).
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
      final json = await _loadFileFromPath(path);
      if (json == null || !mounted) return;

      final counters = _fileStorage.deserialize(json);
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

  Future<String?> _loadFileFromPath(String path) async {
    if (kIsWeb) return null;
    try {
      final result = await _fileStorage.pickAndLoad();
      return result != null ? _fileStorage.serialize(result.counters) : null;
    } catch (_) {
      return null;
    }
  }

  Widget _buildDrawer(AppLocalizations l10n, RecentFilesNotifier recentNotifier,
      bool hasFile) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.note_add),
              title: Text(l10n.createNewFile),
              onTap: () {
                Navigator.of(context).pop();
                _createNewFile();
              },
            ),
            if (hasFile)
              ListTile(
                leading: const Icon(Icons.save_as),
                title: Text(l10n.saveAs),
                onTap: () {
                  Navigator.of(context).pop();
                  _saveAs();
                },
              ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: Text(l10n.openFromFile),
              onTap: () {
                Navigator.of(context).pop();
                _openFromFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.language),
              onTap: () {
                Navigator.of(context).pop();
                _pickLanguage();
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.recentFiles,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  if (recentNotifier.files.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        recentNotifier.clearRecent();
                      },
                      child: Text(l10n.clearRecents),
                    ),
                ],
              ),
            ),
            Expanded(
              child: recentNotifier.files.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noRecentFiles,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: recentNotifier.files.length,
                      itemBuilder: (context, index) {
                        final file = recentNotifier.files[index];
                        return ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(
                            file.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            file.path,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _openRecentFile(file.path, file.name);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.note_add_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.emptyStateTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyStateMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _createNewFile,
              icon: const Icon(Icons.note_add),
              label: Text(l10n.createNewFile),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _openFromFile,
              icon: const Icon(Icons.folder_open),
              label: Text(l10n.openFromFile),
            ),
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
          child: ListView.builder(
            itemCount: counters.counters.length + 1,
            itemBuilder: (context, index) {
              if (index == counters.counters.length) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.red,
                  child:
                      const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (_) => notifier.remove(counter.id),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.fromLTRB(16, 0, 8, 0),
                    title: GestureDetector(
                      onTap: () =>
                          _renameCounter(counter.id, counter.name),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: Text(counter.name)),
                          const SizedBox(width: 4),
                          Icon(Icons.edit,
                              size: 14,
                              color: Theme.of(context).colorScheme.outline),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      '${counter.value}',
                      style:
                          Theme.of(context).textTheme.headlineMedium,
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titleText, style: const TextStyle(fontSize: 18)),
            if (hasFile)
              SavedAgoText(
                lastSavedAt: notifier.lastSavedAt,
                isSaving: notifier.isSaving,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withAlpha(178),
                    ),
              ),
          ],
        ),
      ),
      drawer: _buildDrawer(l10n, recentNotifier, showCounters),
      body: showCounters
          ? _buildCountersList(l10n, notifier)
          : _buildEmptyState(l10n),
    );
  }
}
