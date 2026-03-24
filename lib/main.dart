import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:counter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'state/counter_list_notifier.dart';
import 'state/locale_notifier.dart';
import 'state/recent_files_notifier.dart';
import 'storage/counter_storage.dart';
import 'storage/recent_files_storage.dart';
import 'ui/counters_page.dart';

void main() {
  runApp(const CountersApp());
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
  const CountersApp({super.key});

  static bool get _isApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterListNotifier(CounterStorage())),
        ChangeNotifierProvider(create: (_) => LocaleNotifier()),
        ChangeNotifierProvider(create: (_) => RecentFilesNotifier(RecentFilesStorage())),
      ],
      child: _isApple ? const _CupertinoRoot() : const _MaterialRoot(),
    );
  }
}

class _MaterialRoot extends StatelessWidget {
  const _MaterialRoot();

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
      home: const CountersPage(),
    );
  }
}

class _CupertinoRoot extends StatelessWidget {
  const _CupertinoRoot();

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleNotifier>().locale;
    return CupertinoApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: _delegates,
      supportedLocales: _supportedLocales,
      locale: locale,
      home: const CountersPage(),
    );
  }
}
