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

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get createNewFile => 'إنشاء ملف جديد';

  @override
  String get saveAs => 'حفظ باسم';

  @override
  String get openFromFile => 'فتح من ملف';

  @override
  String get recentFiles => 'الملفات الأخيرة';

  @override
  String get noRecentFiles => 'لا توجد ملفات حديثة';

  @override
  String get language => 'اللغة';

  @override
  String get saving => 'جارٍ الحفظ...';

  @override
  String get savedLessThanMinute => 'تم الحفظ منذ أقل من دقيقة';

  @override
  String savedMinutesAgo(int count) {
    return 'تم الحفظ منذ $count دقائق';
  }

  @override
  String get clearRecents => 'مسح السجل';

  @override
  String get emptyStateTitle => 'مرحباً في عداد متعدد';

  @override
  String get emptyStateMessage =>
      'أنشئ ملف عدادات جديد أو افتح ملفاً موجوداً للبدء.';
}
