// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Счётчики';

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
  String get createNewFile => 'Создать новый файл';

  @override
  String get saveAs => 'Сохранить как';

  @override
  String get openFromFile => 'Открыть из файла';

  @override
  String get recentFiles => 'Недавние файлы';

  @override
  String get noRecentFiles => 'Нет недавних файлов';

  @override
  String get language => 'Язык';

  @override
  String get saving => 'Сохранение...';

  @override
  String get savedLessThanMinute => 'Сохранено менее минуты назад';

  @override
  String savedMinutesAgo(int count) {
    return 'Сохранено $count мин. назад';
  }

  @override
  String get clearRecents => 'Очистить историю';

  @override
  String get emptyStateTitle => 'Добро пожаловать в Счётчики';

  @override
  String get emptyStateMessage =>
      'Создайте новый файл счётчиков или откройте существующий.';

  @override
  String fileNotFound(String name) {
    return 'Файл не найден: $name. Он удалён из списка недавних файлов.';
  }
}
