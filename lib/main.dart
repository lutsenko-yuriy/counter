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
import 'ui/app_fonts.dart';
import 'ui/counters_page.dart';
import 'ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final recentStorage = RecentFilesStorage();
  final fileStorage = CounterFileStorage();

  CounterList? restoredCounters;
  String? restoredFileName;
  String? restoredFilePath;
  final stalePaths = <String>[];

  // Restore from recent files on all native platforms.
  // On desktop, files are at their original paths; on mobile, they are
  // local copies in the app's documents directory.
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF888888),
          primary: const Color(0xFF666666),
          surface: const Color(0xFFF5F0E0),
          onSurface: const Color(0xFF222222),
        ),
        textTheme: AppFonts.materialTextTheme(ThemeData.light().textTheme),
        scaffoldBackgroundColor: const Color(0xFFF5F0E0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F0E0),
          foregroundColor: Color(0xFF333333),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF888888),
          foregroundColor: Color(0xFFF5F0E0),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFFFAF6ED),
          elevation: 2,
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(
        child: CountersPage(staleFilePaths: staleFilePaths),
      ),
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
      theme: CupertinoThemeData(
        primaryColor: const Color(0xFF666666),
        barBackgroundColor: const Color(0xFFB0B0B0),
        scaffoldBackgroundColor: const Color(0xFFF5F0E0),
        textTheme: CupertinoTextThemeData(
          primaryColor: const Color(0xFF444444),
          textStyle: AppFonts.logoStyle(fontSize: 17),
          navTitleTextStyle: AppFonts.logoStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
          navLargeTitleTextStyle: AppFonts.logoStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
          actionTextStyle: AppFonts.logoStyle(
            fontSize: 17,
            color: const Color(0xFF666666),
          ),
        ),
      ),
      home: SplashScreen(
        child: CountersPage(staleFilePaths: staleFilePaths),
      ),
    );
  }
}
