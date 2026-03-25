// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Multi Counter';

  @override
  String get pageTitle => 'Counters';

  @override
  String get noCounters => 'No counters yet. Tap + to add one.';

  @override
  String get swipeToDelete => 'Swipe a counter left to delete it';

  @override
  String get addCounter => 'Add Counter';

  @override
  String get renameCounter => 'Rename Counter';

  @override
  String get nameLabel => 'Name';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get decrement => 'Decrement';

  @override
  String get increment => 'Increment';

  @override
  String get tapToAddCounter => 'Tap to add a new counter';

  @override
  String get untitled => 'Untitled';

  @override
  String get createNewFile => 'Create New File';

  @override
  String get saveAs => 'Save As';

  @override
  String get openFromFile => 'Open from File';

  @override
  String get recentFiles => 'Recent Files';

  @override
  String get noRecentFiles => 'No recent files';

  @override
  String get language => 'Language';

  @override
  String get saving => 'Saving...';

  @override
  String get savedLessThanMinute => 'Saved less than a minute ago';

  @override
  String savedMinutesAgo(int count) {
    return 'Saved $count minutes ago';
  }

  @override
  String get clearRecents => 'Clear Recents';

  @override
  String get emptyStateTitle => 'Welcome to Multi Counter';

  @override
  String get emptyStateMessage =>
      'Create a new counters file or open an existing one to get started.';

  @override
  String fileNotFound(String name) {
    return 'File not found: $name. It has been removed from recent files.';
  }
}
