// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '多计数器';

  @override
  String get pageTitle => '计数器';

  @override
  String get noCounters => '还没有计数器。点击 + 添加一个。';

  @override
  String get swipeToDelete => '向左滑动计数器删除';

  @override
  String get addCounter => '添加计数器';

  @override
  String get renameCounter => '重命名计数器';

  @override
  String get nameLabel => '名称';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get decrement => '减少';

  @override
  String get increment => '增加';

  @override
  String get tapToAddCounter => '点击添加新计数器';

  @override
  String get untitled => '未命名';

  @override
  String get saveToFile => '保存到文件';

  @override
  String get openFromFile => '从文件打开';

  @override
  String get recentFiles => '最近文件';

  @override
  String get noRecentFiles => '没有最近的文件';

  @override
  String get language => '语言';

  @override
  String savedAgo(String time) {
    return '$time前已保存';
  }

  @override
  String get justNow => '刚刚';

  @override
  String secondsAgo(int count) {
    return '$count秒';
  }

  @override
  String minutesAgo(int count) {
    return '$count分钟';
  }

  @override
  String get clearRecents => '清除记录';
}
