import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'state/counter_list_notifier.dart';
import 'state/locale_notifier.dart';
import 'state/recent_files_notifier.dart';
import 'storage/counter_file_storage.dart';
import 'storage/recent_files_storage.dart';
import 'ui/counters_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final recentStorage = RecentFilesStorage();
  final fileStorage = CounterFileStorage();

  CounterList? restoredCounters;
  String? restoredFileName;
  String? restoredFilePath;
  final stalePaths = <String>[];

  if (!kIsWeb) {
    final recentFiles = await recentStorage.load();
    for (final file in recentFiles) {
      try {
        restoredCounters = await fileStorage.loadFromPath(file.path);
        restoredFileName = file.name;
        restoredFilePath = file.path;
        break;
      } catch (_) {
        stalePaths.add(file.path);
      }
    }

    // Remove stale files from recents
    if (stalePaths.isNotEmpty) {
      final cleaned =
          recentFiles.where((f) => !stalePaths.contains(f.path)).toList();
      await recentStorage.save(cleaned);
    }
  }

  runApp(CountersApp(
    initialCounters: restoredCounters,
    initialFileName: restoredFileName,
    initialFilePath: restoredFilePath,
    staleFilePaths: stalePaths,
  ));
}

const _delegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

const _supportedLocales = [
  Locale('en'),
  Locale('de'),
  Locale('fr'),
  Locale('ru'),
  Locale('ar'),
  Locale('zh'),
  Locale('ja'),
];

class CountersApp extends StatelessWidget {
  const CountersApp({
    super.key,
    this.initialCounters,
    this.initialFileName,
    this.initialFilePath,
    this.staleFilePaths = const [],
  });

  final CounterList? initialCounters;
  final String? initialFileName;
  final String? initialFilePath;
  final List<String> staleFilePaths;

  static bool get _isApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CounterListNotifier(
            initialCounters: initialCounters,
            initialFileName: initialFileName,
            initialFilePath: initialFilePath,
          ),
        ),
        ChangeNotifierProvider(create: (_) => LocaleNotifier()),
        ChangeNotifierProvider(
            create: (_) => RecentFilesNotifier(RecentFilesStorage())),
      ],
      child: _isApple
          ? _CupertinoRoot(staleFilePaths: staleFilePaths)
          : _MaterialRoot(staleFilePaths: staleFilePaths),
    );
  }
}

class _MaterialRoot extends StatelessWidget {
  const _MaterialRoot({this.staleFilePaths = const []});

  final List<String> staleFilePaths;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleNotifier>().locale;
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: _delegates,
      supportedLocales: _supportedLocales,
      locale: locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CountersPage(staleFilePaths: staleFilePaths),
    );
  }
}

class _CupertinoRoot extends StatelessWidget {
  const _CupertinoRoot({this.staleFilePaths = const []});

  final List<String> staleFilePaths;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleNotifier>().locale;
    return CupertinoApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: _delegates,
      supportedLocales: _supportedLocales,
      locale: locale,
      home: CountersPage(staleFilePaths: staleFilePaths),
    );
  }
}
