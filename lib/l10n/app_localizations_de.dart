// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Multi-Zähler';

  @override
  String get pageTitle => 'Zähler';

  @override
  String get noCounters =>
      'Noch keine Zähler. Tippe auf + um einen hinzuzufügen.';

  @override
  String get swipeToDelete => 'Zähler nach links wischen zum Löschen';

  @override
  String get addCounter => 'Zähler hinzufügen';

  @override
  String get renameCounter => 'Zähler umbenennen';

  @override
  String get nameLabel => 'Name';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get decrement => 'Verringern';

  @override
  String get increment => 'Erhöhen';

  @override
  String get tapToAddCounter => 'Tippen, um einen neuen Zähler hinzuzufügen';
}
