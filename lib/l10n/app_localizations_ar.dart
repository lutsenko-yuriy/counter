// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'عداد متعدد';

  @override
  String get pageTitle => 'العدادات';

  @override
  String get noCounters => 'لا توجد عدادات. اضغط + لإضافة واحد.';

  @override
  String get swipeToDelete => 'اسحب العداد يميناً للحذف';

  @override
  String get addCounter => 'إضافة عداد';

  @override
  String get renameCounter => 'إعادة تسمية العداد';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get decrement => 'تقليل';

  @override
  String get increment => 'زيادة';

  @override
  String get tapToAddCounter => 'اضغط لإضافة عداد جديد';
}
