// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Zähler';

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

  @override
  String get untitled => 'Unbenannt';

  @override
  String get createNewFile => 'Neue Datei erstellen';

  @override
  String get saveAs => 'Speichern unter';

  @override
  String get openFromFile => 'Aus Datei öffnen';

  @override
  String get recentFiles => 'Zuletzt geöffnet';

  @override
  String get noRecentFiles => 'Keine zuletzt geöffneten Dateien';

  @override
  String get language => 'Sprache';

  @override
  String get saving => 'Speichern...';

  @override
  String get savedLessThanMinute => 'Vor weniger als einer Minute gespeichert';

  @override
  String savedMinutesAgo(int count) {
    return 'Vor $count Minuten gespeichert';
  }

  @override
  String get clearRecents => 'Verlauf löschen';

  @override
  String get emptyStateTitle => 'Willkommen bei Zähler';

  @override
  String get emptyStateMessage =>
      'Erstelle eine neue Zähler-Datei oder öffne eine vorhandene.';

  @override
  String fileNotFound(String name) {
    return 'Datei nicht gefunden: $name. Sie wurde aus den zuletzt geöffneten Dateien entfernt.';
  }
}
