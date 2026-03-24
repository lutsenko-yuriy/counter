// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Мульти-счётчик';

  @override
  String get pageTitle => 'Счётчики';

  @override
  String get noCounters => 'Нет счётчиков. Нажмите + чтобы добавить.';

  @override
  String get swipeToDelete => 'Смахните счётчик влево для удаления';

  @override
  String get addCounter => 'Добавить счётчик';

  @override
  String get renameCounter => 'Переименовать счётчик';

  @override
  String get nameLabel => 'Название';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get decrement => 'Уменьшить';

  @override
  String get increment => 'Увеличить';

  @override
  String get tapToAddCounter => 'Нажмите, чтобы добавить новый счётчик';

  @override
  String get untitled => 'Без названия';

  @override
  String get saveToFile => 'Сохранить в файл';

  @override
  String get openFromFile => 'Открыть из файла';

  @override
  String get recentFiles => 'Недавние файлы';

  @override
  String get noRecentFiles => 'Нет недавних файлов';

  @override
  String get language => 'Язык';

  @override
  String savedAgo(String time) {
    return 'Сохранено $time назад';
  }

  @override
  String get justNow => 'только что';

  @override
  String secondsAgo(int count) {
    return '$countс';
  }

  @override
  String minutesAgo(int count) {
    return '$countм';
  }

  @override
  String get clearRecents => 'Очистить историю';
}
