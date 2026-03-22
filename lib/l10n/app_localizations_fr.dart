// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Multi Compteur';

  @override
  String get pageTitle => 'Compteurs';

  @override
  String get noCounters => 'Aucun compteur. Appuyez sur + pour en ajouter un.';

  @override
  String get swipeToDelete => 'Glisser un compteur à gauche pour le supprimer';

  @override
  String get addCounter => 'Ajouter un compteur';

  @override
  String get renameCounter => 'Renommer le compteur';

  @override
  String get nameLabel => 'Nom';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get decrement => 'Décrémenter';

  @override
  String get increment => 'Incrémenter';

  @override
  String get tapToAddCounter => 'Appuyez pour ajouter un nouveau compteur';
}
