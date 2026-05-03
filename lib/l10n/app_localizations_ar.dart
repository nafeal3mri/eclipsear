// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String eclipseType(String eclipseType) {
    String _temp0 = intl.Intl.selectLogic(
      eclipseType,
      {
        'solarnotVisible': 'غير ظاهر في منطقتك',
        'solartotalEclipse': 'كسوف شمس كلي',
        'solarannularEclipse': 'كسوف شمس حلقي',
        'solarpartialEclipse': 'كسوف شمس جزئي',
        'lunarnotVisible': 'غير ظاهر في منطقتك',
        'lunartotalEclipse': 'خسوف قمر كلي',
        'lunarannularEclipse': 'خسوف قمر حلقي',
        'lunarpartialEclipse': 'خسوف قمر جزئي',
        'lunarpenumbralEclipse': 'خسوف قمر شبه ظلي',
        'other': 'لا يوجد بيانات',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => 'يوم';

  @override
  String get year => 'سنة';

  @override
  String get years => 'سنوات';

  @override
  String get month => 'شهر';

  @override
  String get months => 'أشهر';

  @override
  String get viewMore => 'عرض المزيد';

  @override
  String get max => 'ذروة الكسوف';

  @override
  String get start => 'بداية الكسوف';

  @override
  String get end => 'نهاية الكسوف';

  @override
  String get solarEclipse => 'كسوف الشمس';

  @override
  String get lunarEclipse => 'خسوف القمر';

  @override
  String get settings => 'الاعدادات';

  @override
  String get language => 'Language';

  @override
  String get location => 'الموقع';

  @override
  String get setLocation => 'اختر الموقع';

  @override
  String get selectFromMap => 'اختر من خريطة';

  @override
  String get selectFromList => 'اختر من قائمة';

  @override
  String get eclipseDetails => 'تفاصيل الكسوف';

  @override
  String get viewEclipseMap => 'استعرض خريطة الكسوف';

  @override
  String get eclipsePath => 'مسار الكسوف';

  @override
  String get eclipseSimulation => 'محاكاة الكسوف';

  @override
  String ecVisibility(String EclipseVisibility) {
    String _temp0 = intl.Intl.selectLogic(
      EclipseVisibility,
      {
        'notVisibleShort': 'غير ممكنة',
        'other': 'ممكنة',
      },
    );
    return '$_temp0';
  }

  @override
  String get visibility => 'امكانية المشاهدة';

  @override
  String get eclipseTypes => 'نوع الكسوف';

  @override
  String get date => 'التاريخ';

  @override
  String get magnitude => 'حجم الكسوف';

  @override
  String get coverage => 'التغطية';

  @override
  String get hours => 'ساعة';

  @override
  String get minutes => 'دقيقة';

  @override
  String get and => 'و';

  @override
  String get douration => 'المدة';

  @override
  String get aboutus => 'عن EclipseAR';

  @override
  String get learnaboutus => 'تعرف علينا :)';

  @override
  String get aboutuscontent =>
      'تطبيق EclipseAR هو تطبيق لحساب مواعيد خسوف القمر وكسوف الشمس, تم برمجة هذا التطبيق بالاستعانة ببعض المصادر \n - NASA (https://eclipse.gsfc.nasa.gov) \n - © Dominic Ford (https://in-the-sky.org) \n لا يطلب هذا التطبيق اي اذونات خاصة عدا أذونات اختيارية (الموقع الجغرافي) يمكنك تفعيلها والغاء تفعيلها في أي وقت \n تابعني على منصات التواصل الاجتماعي Twitter - snapchat - Instagram @nafe_al3mri \n If you interested to help translate this app to your language please contact me at info@nafe.me';

  @override
  String get eclipseended => 'انتهى الكسوف';

  @override
  String get solar => 'كسوف الشمس';

  @override
  String get lunar => 'خسوف القمر';

  @override
  String get lastYearForecast => 'توقعات طقس العام الماضي';

  @override
  String get eclipseDiagram => 'صورة الكسوف';

  @override
  String get loadingEclipsePath => 'جاري تحميل مسار الكسوف…';

  @override
  String get loadingSimulation => 'جاري تحميل المحاكاة…';

  @override
  String get diagramUnavailable => 'الصورة غير متاحة';

  @override
  String get simulationUnavailable => 'المحاكاة غير متاحة لهذا الكسوف';

  @override
  String get simulationAttribution => 'محاكاة © Dominic Ford / in-the-sky.org';

  @override
  String get noUpcomingSolarEclipse => 'لا توجد بيانات لكسوف الشمس';

  @override
  String get noUpcomingLunarEclipse => 'لا توجد بيانات لخسوف القمر';

  @override
  String get eclipseForecast => 'توقعات الكسوف';

  @override
  String get next10Years => 'السنوات العشر القادمة';

  @override
  String get noEclipsesInRange => 'لا توجد كسوفات في هذا النطاق';

  @override
  String get next => 'التالي';

  @override
  String get past => 'ماضي';

  @override
  String daysAbbr(Object count) {
    return '$count ي';
  }

  @override
  String monthsAbbr(Object count) {
    return '$count شهر';
  }

  @override
  String yearsAbbr(Object count) {
    return '$count سنة';
  }

  @override
  String get nextEclipse => 'الكسوف القادم';

  @override
  String get seeDetails => 'عرض التفاصيل';

  @override
  String get upcomingEclipses => 'الكسوفات القادمة';

  @override
  String get hrs => 'ساعة';

  @override
  String get mins => 'دقيقة';

  @override
  String get secs => 'ثانية';

  @override
  String get sectionPreferences => 'التفضيلات';

  @override
  String get sectionApp => 'التطبيق';

  @override
  String get pleaseSelectLocation => 'الرجاء اختيار الموقع';

  @override
  String get tapAnywhereOnMap => 'انقر في أي مكان على الخريطة';

  @override
  String get eclipseNotVisible => 'هذا الكسوف غير مرئي من موقعك';

  @override
  String get eclipseAlreadyPassed => 'هذا الكسوف قد مضى';

  @override
  String get reminderSet => 'تم ضبط التذكير! ستتلقى إشعاراً قبل الكسوف';

  @override
  String get sharedViaEclipsear => 'تمت المشاركة عبر EclipseAR';

  @override
  String get typeTotal => 'كلي';

  @override
  String get typeAnnular => 'حلقي';

  @override
  String get typePartial => 'جزئي';

  @override
  String get typePenumbral => 'شبه ظلي';

  @override
  String get typeNotVisible => 'غير مرئي';

  @override
  String get welcomeTagline =>
      'دليلك الشخصي لكل كسوف شمسي وخسوف قمري على الأرض';

  @override
  String get welcomeChipCountdown => 'العد التنازلي';

  @override
  String get welcomeSlide2Title => 'ما ستشاهده';

  @override
  String get welcomeSlide2Subtitle => 'كل شيء عن كل كسوف، خصيصاً لموقعك.';

  @override
  String get welcomeFeatureSolarBody =>
      'كلي، حلقي وجزئي — اعرف النوع والمسار والعد التنازلي';

  @override
  String get welcomeFeatureLunarBody =>
      'القمر الدموي، شبه الظلي والمزيد — لا تفوّت أي حدث قمري';

  @override
  String get welcomeFeatureWeather => 'طقس العام الماضي';

  @override
  String get welcomeFeatureWeatherBody =>
      'اعرف توقعات الطقس من العام الماضي في يوم الكسوف لتخطط مسبقاً.';

  @override
  String get welcomeFeatureMap => 'خريطة مسار الكسوف';

  @override
  String get welcomeFeatureMapBody =>
      'استعرض المسار الكامل للكسوف الكلي على خريطة تفاعلية.';

  @override
  String get welcomeSlide3Title => 'حدد موقعك';

  @override
  String get welcomeSlide3Body =>
      'يحتاج EclipseAR إلى موقعك لحساب إمكانية مشاهدة الكسوف ونوعه وتوقيته بدقة لمكان وجودك.';

  @override
  String get welcomeUseGPS => 'استخدم GPS';

  @override
  String get welcomePickOnMap => 'اختر على الخريطة';

  @override
  String get welcomeSkip => 'تخطي الآن';
}
