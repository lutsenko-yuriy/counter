// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'マルチカウンター';

  @override
  String get pageTitle => 'カウンター';

  @override
  String get noCounters => 'カウンターがありません。＋ で追加してください。';

  @override
  String get swipeToDelete => 'カウンターを左にスワイプして削除';

  @override
  String get addCounter => 'カウンターを追加';

  @override
  String get renameCounter => 'カウンターの名前を変更';

  @override
  String get nameLabel => '名前';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get decrement => '減らす';

  @override
  String get increment => '増やす';

  @override
  String get tapToAddCounter => 'タップして新しいカウンターを追加';

  @override
  String get untitled => '無題';

  @override
  String get saveToFile => 'ファイルに保存';

  @override
  String get openFromFile => 'ファイルから開く';

  @override
  String get recentFiles => '最近のファイル';

  @override
  String get noRecentFiles => '最近のファイルはありません';

  @override
  String get language => '言語';

  @override
  String savedAgo(String time) {
    return '$time前に保存';
  }

  @override
  String get justNow => 'たった今';

  @override
  String secondsAgo(int count) {
    return '$count秒';
  }

  @override
  String minutesAgo(int count) {
    return '$count分';
  }

  @override
  String get clearRecents => '履歴をクリア';
}
