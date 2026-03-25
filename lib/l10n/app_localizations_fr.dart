// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Compteurs';

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

  @override
  String get untitled => 'Sans titre';

  @override
  String get createNewFile => 'Créer un nouveau fichier';

  @override
  String get saveAs => 'Enregistrer sous';

  @override
  String get openFromFile => 'Ouvrir un fichier';

  @override
  String get recentFiles => 'Fichiers récents';

  @override
  String get noRecentFiles => 'Aucun fichier récent';

  @override
  String get language => 'Langue';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get savedLessThanMinute => 'Enregistré il y a moins d\'une minute';

  @override
  String savedMinutesAgo(int count) {
    return 'Enregistré il y a $count minutes';
  }

  @override
  String get clearRecents => 'Effacer les récents';

  @override
  String get emptyStateTitle => 'Bienvenue dans Compteurs';

  @override
  String get emptyStateMessage =>
      'Créez un nouveau fichier de compteurs ou ouvrez-en un existant.';

  @override
  String fileNotFound(String name) {
    return 'Fichier introuvable : $name. Il a été supprimé des fichiers récents.';
  }
}
