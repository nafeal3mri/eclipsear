// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String eclipseType(String eclipseType) {
    String _temp0 = intl.Intl.selectLogic(
      eclipseType,
      {
        'solarnotVisible': 'Not visible in your location',
        'solartotalEclipse': 'Total Solar Eclipse',
        'solarannularEclipse': 'Annular Solar Eclipse',
        'solarpartialEclipse': 'Partial Solar Eclipse',
        'lunarnotVisible': 'Not visible in your location',
        'lunartotalEclipse': 'Total Lunar Eclipse',
        'lunarannularEclipse': 'Annular Lunar Eclipse',
        'lunarpartialEclipse': 'Partial Lunar Eclipse',
        'lunarpenumbralEclipse': 'Penumbral Lunar Eclipse',
        'other': 'No data',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => 'Days';

  @override
  String get year => 'Year';

  @override
  String get years => 'Years';

  @override
  String get month => 'Month';

  @override
  String get months => 'Months';

  @override
  String get viewMore => 'View More';

  @override
  String get max => 'Max';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get solarEclipse => 'Solar Eclipse';

  @override
  String get lunarEclipse => 'Lunar Eclipse';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'اللغة';

  @override
  String get location => 'Location';

  @override
  String get setLocation => 'Set location';

  @override
  String get selectFromMap => 'Select from Map';

  @override
  String get selectFromList => 'Select from list';

  @override
  String get eclipseDetails => 'Eclipse details';

  @override
  String get viewEclipseMap => 'View eclipse map';

  @override
  String get eclipsePath => 'Eclipse path';

  @override
  String get eclipseSimulation => 'Eclipse simulation';

  @override
  String ecVisibility(String EclipseVisibility) {
    String _temp0 = intl.Intl.selectLogic(
      EclipseVisibility,
      {
        'notVisibleShort': 'Not visible',
        'other': 'Visible',
      },
    );
    return '$_temp0';
  }

  @override
  String get visibility => 'Visibility';

  @override
  String get eclipseTypes => 'Eclipse type';

  @override
  String get date => 'Date';

  @override
  String get magnitude => 'Magnitude';

  @override
  String get coverage => 'Coverage';

  @override
  String get hours => 'Hours';

  @override
  String get minutes => 'Minutes';

  @override
  String get and => '&';

  @override
  String get douration => 'Douration';

  @override
  String get aboutus => 'About EclipseAR';

  @override
  String get learnaboutus => 'Want to know about us?';

  @override
  String get aboutuscontent =>
      'EclipseAR is a solar/lunar eclipse calender, some sources were used to make this app \n - NASA (https://eclipse.gsfc.nasa.gov) \n - © Dominic Ford (https://in-the-sky.org) \n This app DO NOT require any spicial permissions to your phone (Except Geolocation), it\'s optional, you can disable it whenever you want. \n If you interested to help translate this app to your language please contact me at info@nafe.me';

  @override
  String get eclipseended => 'Eclipse Ended';

  @override
  String get solar => 'Solar';

  @override
  String get lunar => 'Lunar';

  @override
  String get lastYearForecast => 'Last Year Forecast';

  @override
  String get eclipseDiagram => 'Eclipse Diagram';

  @override
  String get loadingEclipsePath => 'Loading eclipse path…';

  @override
  String get loadingSimulation => 'Loading simulation…';

  @override
  String get diagramUnavailable => 'Diagram unavailable';

  @override
  String get simulationUnavailable =>
      'Simulation not available for this eclipse';

  @override
  String get simulationAttribution =>
      'Simulation © Dominic Ford / in-the-sky.org';

  @override
  String get noUpcomingSolarEclipse => 'No upcoming solar eclipse data';

  @override
  String get noUpcomingLunarEclipse => 'No upcoming lunar eclipse data';

  @override
  String get eclipseForecast => 'Eclipse Forecast';

  @override
  String get next10Years => 'Next 10 years';

  @override
  String get noEclipsesInRange => 'No eclipses in range';

  @override
  String get next => 'NEXT';

  @override
  String get past => 'Past';

  @override
  String daysAbbr(Object count) {
    return '$count d';
  }

  @override
  String monthsAbbr(Object count) {
    return '$count mo';
  }

  @override
  String yearsAbbr(Object count) {
    return '$count yr';
  }

  @override
  String get nextEclipse => 'NEXT ECLIPSE';

  @override
  String get seeDetails => 'See details';

  @override
  String get upcomingEclipses => 'Upcoming Eclipses';

  @override
  String get hrs => 'HRS';

  @override
  String get mins => 'MINS';

  @override
  String get secs => 'SECS';

  @override
  String get sectionPreferences => 'Preferences';

  @override
  String get sectionApp => 'App';

  @override
  String get pleaseSelectLocation => 'Please select a location';

  @override
  String get tapAnywhereOnMap => 'Tap anywhere on the map';

  @override
  String get eclipseNotVisible =>
      'This eclipse is not visible from your location';

  @override
  String get eclipseAlreadyPassed => 'This eclipse has already passed';

  @override
  String get reminderSet =>
      'Reminder set! You\'ll be notified before the eclipse';

  @override
  String get sharedViaEclipsear => 'Shared via EclipseAR';

  @override
  String get typeTotal => 'Total';

  @override
  String get typeAnnular => 'Annular';

  @override
  String get typePartial => 'Partial';

  @override
  String get typePenumbral => 'Penumbral';

  @override
  String get typeNotVisible => 'Not visible';

  @override
  String get welcomeTagline => 'Select language';

  @override
  String get welcomeChipCountdown => 'Countdown';

  @override
  String get welcomeSlide2Title => 'What you\'ll see';

  @override
  String get welcomeSlide2Subtitle =>
      'Everything about every eclipse, just for your location.';

  @override
  String get welcomeFeatureSolarBody =>
      'Total, annular & partial — see type, path and countdown';

  @override
  String get welcomeFeatureLunarBody =>
      'Blood moon, penumbral & more — never miss a lunar event';

  @override
  String get welcomeFeatureWeather => 'Historical Weather';

  @override
  String get welcomeFeatureWeatherBody =>
      'See the weather forecast from last year on the eclipse date so you can plan ahead.';

  @override
  String get welcomeFeatureMap => 'Eclipse Path Map';

  @override
  String get welcomeFeatureMapBody =>
      'View the full path of totality on an interactive map.';

  @override
  String get welcomeSlide3Title => 'Set your location';

  @override
  String get welcomeSlide3Body =>
      'EclipseAR needs your location to calculate eclipse visibility, type, and timing specifically for where you are.';

  @override
  String get welcomeUseGPS => 'Use GPS';

  @override
  String get welcomePickOnMap => 'Pick on Map';

  @override
  String get welcomeSkip => 'Skip for now';

  @override
  String get addReminder => 'Add reminder';

  @override
  String get share => 'Share';
}
