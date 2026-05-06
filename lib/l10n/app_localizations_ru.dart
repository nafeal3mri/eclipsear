// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String eclipseType(String eclipseType) {
    String _temp0 = intl.Intl.selectLogic(
      eclipseType,
      {
        'solarnotVisible': 'Не видно в вашем месте',
        'solartotalEclipse': 'Полное солнечное затмение',
        'solarannularEclipse': 'Кольцеобразное солнечное затмение',
        'solarpartialEclipse': 'Частичное солнечное затмение',
        'lunarnotVisible': 'Не видно в вашем месте',
        'lunartotalEclipse': 'Полное лунное затмение',
        'lunarannularEclipse': 'Кольцеобразное лунное затмение',
        'lunarpartialEclipse': 'Частичное лунное затмение',
        'lunarpenumbralEclipse': 'Полутеневое лунное затмение',
        'other': 'Нет данных',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => 'Дни';

  @override
  String get year => 'Год';

  @override
  String get years => 'Годы';

  @override
  String get month => 'Месяц';

  @override
  String get months => 'Месяцы';

  @override
  String get viewMore => 'Подробнее';

  @override
  String get max => 'Макс';

  @override
  String get start => 'Начало';

  @override
  String get end => 'Конец';

  @override
  String get solarEclipse => 'Солнечное затмение';

  @override
  String get lunarEclipse => 'Лунное затмение';

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get location => 'Местоположение';

  @override
  String get setLocation => 'Установить местоположение';

  @override
  String get selectFromMap => 'Выбрать на карте';

  @override
  String get selectFromList => 'Выбрать из списка';

  @override
  String get eclipseDetails => 'Детали затмения';

  @override
  String get viewEclipseMap => 'Посмотреть карту затмения';

  @override
  String get eclipsePath => 'Траектория затмения';

  @override
  String get eclipseSimulation => 'Симуляция затмения';

  @override
  String ecVisibility(String EclipseVisibility) {
    String _temp0 = intl.Intl.selectLogic(
      EclipseVisibility,
      {
        'notVisibleShort': 'Не видно',
        'other': 'Видно',
      },
    );
    return '$_temp0';
  }

  @override
  String get visibility => 'Видимость';

  @override
  String get eclipseTypes => 'Тип затмения';

  @override
  String get date => 'Дата';

  @override
  String get magnitude => 'Величина';

  @override
  String get coverage => 'Покрытие';

  @override
  String get hours => 'Часы';

  @override
  String get minutes => 'Минуты';

  @override
  String get and => '&';

  @override
  String get douration => 'Длительность';

  @override
  String get aboutus => 'О EclipseAR';

  @override
  String get learnaboutus => 'Хотите узнать о нас?';

  @override
  String get aboutuscontent =>
      'EclipseAR is a solar/lunar eclipse calender, some sources were used to make this app \n - NASA (https://eclipse.gsfc.nasa.gov) \n - © Dominic Ford (https://in-the-sky.org) \n This app DO NOT require any spicial permissions to your phone (Except Geolocation), it\'s optional, you can disable it whenever you want. \n If you interested to help translate this app to your language please contact me at info@nafe.me';

  @override
  String get eclipseended => 'Затмение завершилось';

  @override
  String get solar => 'Солнечное';

  @override
  String get lunar => 'Лунное';

  @override
  String get lastYearForecast => 'Прогноз за прошлый год';

  @override
  String get eclipseDiagram => 'Схема затмения';

  @override
  String get loadingEclipsePath => 'Загрузка траектории затмения…';

  @override
  String get loadingSimulation => 'Загрузка симуляции…';

  @override
  String get diagramUnavailable => 'Схема недоступна';

  @override
  String get simulationUnavailable => 'Симуляция недоступна для этого затмения';

  @override
  String get simulationAttribution =>
      'Симуляция © Dominic Ford / in-the-sky.org';

  @override
  String get noUpcomingSolarEclipse =>
      'Нет данных о предстоящих солнечных затмениях';

  @override
  String get noUpcomingLunarEclipse =>
      'Нет данных о предстоящих лунных затмениях';

  @override
  String get eclipseForecast => 'Прогноз затмения';

  @override
  String get next10Years => 'Следующие 10 лет';

  @override
  String get noEclipsesInRange => 'Нет затмений в этом диапазоне';

  @override
  String get next => 'СЛЕДУЮЩЕЕ';

  @override
  String get past => 'Прошедшие';

  @override
  String daysAbbr(Object count) {
    return '$count д';
  }

  @override
  String monthsAbbr(Object count) {
    return '$count мес';
  }

  @override
  String yearsAbbr(Object count) {
    return '$count г';
  }

  @override
  String get nextEclipse => 'СЛЕДУЮЩЕЕ ЗАТМЕНИЕ';

  @override
  String get seeDetails => 'Подробнее';

  @override
  String get upcomingEclipses => 'Предстоящие затмения';

  @override
  String get hrs => 'Ч';

  @override
  String get mins => 'МИН';

  @override
  String get secs => 'СЕК';

  @override
  String get sectionPreferences => 'Предпочтения';

  @override
  String get sectionApp => 'Приложение';

  @override
  String get pleaseSelectLocation => 'Пожалуйста, выберите местоположение';

  @override
  String get tapAnywhereOnMap => 'Нажмите в любом месте карты';

  @override
  String get eclipseNotVisible => 'Это затмение не видно из вашего места';

  @override
  String get eclipseAlreadyPassed => 'Это затмение уже прошло';

  @override
  String get reminderSet =>
      'Напоминание установлено! Вы получите уведомление перед затмением';

  @override
  String get sharedViaEclipsear => 'Поделено через EclipseAR';

  @override
  String get typeTotal => 'Полное';

  @override
  String get typeAnnular => 'Кольцеобразное';

  @override
  String get typePartial => 'Частичное';

  @override
  String get typePenumbral => 'Полутеневое';

  @override
  String get typeNotVisible => 'Не видно';

  @override
  String get welcomeTagline => 'Выберите язык';

  @override
  String get welcomeChipCountdown => 'Обратный отсчет';

  @override
  String get welcomeSlide2Title => 'Что вы увидите';

  @override
  String get welcomeSlide2Subtitle =>
      'Все о каждом затмении — для вашего местоположения.';

  @override
  String get welcomeFeatureSolarBody =>
      'Полное, кольцеобразное и частичное — тип, путь и отсчет';

  @override
  String get welcomeFeatureLunarBody =>
      'Кровавая луна, полутеневое и другое — не пропустите лунные события';

  @override
  String get welcomeFeatureWeather => 'Историческая погода';

  @override
  String get welcomeFeatureWeatherBody =>
      'Посмотрите прогноз за прошлый год на дату затмения, чтобы спланировать заранее.';

  @override
  String get welcomeFeatureMap => 'Карта пути затмения';

  @override
  String get welcomeFeatureMapBody =>
      'Посмотрите полный путь тотальности на интерактивной карте.';

  @override
  String get welcomeSlide3Title => 'Укажите местоположение';

  @override
  String get welcomeSlide3Body =>
      'EclipseAR нужно ваше местоположение, чтобы рассчитать видимость, тип и время затмения для вас.';

  @override
  String get welcomeUseGPS => 'Использовать GPS';

  @override
  String get welcomePickOnMap => 'Выбрать на карте';

  @override
  String get welcomeSkip => 'Пропустить';

  @override
  String get addReminder => 'Добавить напоминание';

  @override
  String get share => 'Поделиться';
}
