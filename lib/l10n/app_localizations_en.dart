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
}
