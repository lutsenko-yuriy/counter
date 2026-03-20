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
}
