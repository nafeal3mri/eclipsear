import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @eclipseType.
  ///
  /// In en, this message translates to:
  /// **'{eclipseType, select, solarnotVisible{Not visible in your location} solartotalEclipse{Total Solar Eclipse} solarannularEclipse{Annular Solar Eclipse} solarpartialEclipse{Partial Solar Eclipse} lunarnotVisible{Not visible in your location} lunartotalEclipse{Total Lunar Eclipse} lunarannularEclipse{Annular Lunar Eclipse} lunarpartialEclipse{Partial Lunar Eclipse} lunarpenumbralEclipse{Penumbral Lunar Eclipse} other{No data}}'**
  String eclipseType(String eclipseType);

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get viewMore;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @solarEclipse.
  ///
  /// In en, this message translates to:
  /// **'Solar Eclipse'**
  String get solarEclipse;

  /// No description provided for @lunarEclipse.
  ///
  /// In en, this message translates to:
  /// **'Lunar Eclipse'**
  String get lunarEclipse;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @setLocation.
  ///
  /// In en, this message translates to:
  /// **'Set location'**
  String get setLocation;

  /// No description provided for @selectFromMap.
  ///
  /// In en, this message translates to:
  /// **'Select from Map'**
  String get selectFromMap;

  /// No description provided for @selectFromList.
  ///
  /// In en, this message translates to:
  /// **'Select from list'**
  String get selectFromList;

  /// No description provided for @eclipseDetails.
  ///
  /// In en, this message translates to:
  /// **'Eclipse details'**
  String get eclipseDetails;

  /// No description provided for @viewEclipseMap.
  ///
  /// In en, this message translates to:
  /// **'View eclipse map'**
  String get viewEclipseMap;

  /// No description provided for @eclipsePath.
  ///
  /// In en, this message translates to:
  /// **'Eclipse path'**
  String get eclipsePath;

  /// No description provided for @eclipseSimulation.
  ///
  /// In en, this message translates to:
  /// **'Eclipse simulation'**
  String get eclipseSimulation;

  /// No description provided for @ecVisibility.
  ///
  /// In en, this message translates to:
  /// **'{EclipseVisibility, select,  notVisibleShort{Not visible} other{Visible}}'**
  String ecVisibility(String EclipseVisibility);

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @eclipseTypes.
  ///
  /// In en, this message translates to:
  /// **'Eclipse type'**
  String get eclipseTypes;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @magnitude.
  ///
  /// In en, this message translates to:
  /// **'Magnitude'**
  String get magnitude;

  /// No description provided for @coverage.
  ///
  /// In en, this message translates to:
  /// **'Coverage'**
  String get coverage;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'&'**
  String get and;

  /// No description provided for @douration.
  ///
  /// In en, this message translates to:
  /// **'Douration'**
  String get douration;

  /// No description provided for @aboutus.
  ///
  /// In en, this message translates to:
  /// **'About EclipseAR'**
  String get aboutus;

  /// No description provided for @learnaboutus.
  ///
  /// In en, this message translates to:
  /// **'Want to know about us?'**
  String get learnaboutus;

  /// No description provided for @aboutuscontent.
  ///
  /// In en, this message translates to:
  /// **'EclipseAR is a solar/lunar eclipse calender, some sources were used to make this app \n - NASA (https://eclipse.gsfc.nasa.gov) \n - © Dominic Ford (https://in-the-sky.org) \n This app DO NOT require any spicial permissions to your phone (Except Geolocation), it\'s optional, you can disable it whenever you want. \n If you interested to help translate this app to your language please contact me at info@nafe.me'**
  String get aboutuscontent;

  /// No description provided for @eclipseended.
  ///
  /// In en, this message translates to:
  /// **'Eclipse Ended'**
  String get eclipseended;

  /// No description provided for @solar.
  ///
  /// In en, this message translates to:
  /// **'Solar'**
  String get solar;

  /// No description provided for @lunar.
  ///
  /// In en, this message translates to:
  /// **'Lunar'**
  String get lunar;

  /// No description provided for @lastYearForecast.
  ///
  /// In en, this message translates to:
  /// **'Last Year Forecast'**
  String get lastYearForecast;

  /// No description provided for @eclipseDiagram.
  ///
  /// In en, this message translates to:
  /// **'Eclipse Diagram'**
  String get eclipseDiagram;

  /// No description provided for @loadingEclipsePath.
  ///
  /// In en, this message translates to:
  /// **'Loading eclipse path…'**
  String get loadingEclipsePath;

  /// No description provided for @loadingSimulation.
  ///
  /// In en, this message translates to:
  /// **'Loading simulation…'**
  String get loadingSimulation;

  /// No description provided for @diagramUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Diagram unavailable'**
  String get diagramUnavailable;

  /// No description provided for @simulationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Simulation not available for this eclipse'**
  String get simulationUnavailable;

  /// No description provided for @simulationAttribution.
  ///
  /// In en, this message translates to:
  /// **'Simulation © Dominic Ford / in-the-sky.org'**
  String get simulationAttribution;

  /// No description provided for @noUpcomingSolarEclipse.
  ///
  /// In en, this message translates to:
  /// **'No upcoming solar eclipse data'**
  String get noUpcomingSolarEclipse;

  /// No description provided for @noUpcomingLunarEclipse.
  ///
  /// In en, this message translates to:
  /// **'No upcoming lunar eclipse data'**
  String get noUpcomingLunarEclipse;

  /// No description provided for @eclipseForecast.
  ///
  /// In en, this message translates to:
  /// **'Eclipse Forecast'**
  String get eclipseForecast;

  /// No description provided for @next10Years.
  ///
  /// In en, this message translates to:
  /// **'Next 10 years'**
  String get next10Years;

  /// No description provided for @noEclipsesInRange.
  ///
  /// In en, this message translates to:
  /// **'No eclipses in range'**
  String get noEclipsesInRange;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get next;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @daysAbbr.
  ///
  /// In en, this message translates to:
  /// **'{count} d'**
  String daysAbbr(Object count);

  /// No description provided for @monthsAbbr.
  ///
  /// In en, this message translates to:
  /// **'{count} mo'**
  String monthsAbbr(Object count);

  /// No description provided for @yearsAbbr.
  ///
  /// In en, this message translates to:
  /// **'{count} yr'**
  String yearsAbbr(Object count);

  /// No description provided for @nextEclipse.
  ///
  /// In en, this message translates to:
  /// **'NEXT ECLIPSE'**
  String get nextEclipse;

  /// No description provided for @seeDetails.
  ///
  /// In en, this message translates to:
  /// **'See details'**
  String get seeDetails;

  /// No description provided for @upcomingEclipses.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Eclipses'**
  String get upcomingEclipses;

  /// No description provided for @hrs.
  ///
  /// In en, this message translates to:
  /// **'HRS'**
  String get hrs;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'MINS'**
  String get mins;

  /// No description provided for @secs.
  ///
  /// In en, this message translates to:
  /// **'SECS'**
  String get secs;

  /// No description provided for @sectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get sectionPreferences;

  /// No description provided for @sectionApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get sectionApp;

  /// No description provided for @pleaseSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select a location'**
  String get pleaseSelectLocation;

  /// No description provided for @tapAnywhereOnMap.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere on the map'**
  String get tapAnywhereOnMap;

  /// No description provided for @eclipseNotVisible.
  ///
  /// In en, this message translates to:
  /// **'This eclipse is not visible from your location'**
  String get eclipseNotVisible;

  /// No description provided for @eclipseAlreadyPassed.
  ///
  /// In en, this message translates to:
  /// **'This eclipse has already passed'**
  String get eclipseAlreadyPassed;

  /// No description provided for @reminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder set! You\'ll be notified before the eclipse'**
  String get reminderSet;

  /// No description provided for @sharedViaEclipsear.
  ///
  /// In en, this message translates to:
  /// **'Shared via EclipseAR'**
  String get sharedViaEclipsear;

  /// No description provided for @typeTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get typeTotal;

  /// No description provided for @typeAnnular.
  ///
  /// In en, this message translates to:
  /// **'Annular'**
  String get typeAnnular;

  /// No description provided for @typePartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get typePartial;

  /// No description provided for @typePenumbral.
  ///
  /// In en, this message translates to:
  /// **'Penumbral'**
  String get typePenumbral;

  /// No description provided for @typeNotVisible.
  ///
  /// In en, this message translates to:
  /// **'Not visible'**
  String get typeNotVisible;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Your personal guide to every solar & lunar eclipse on Earth'**
  String get welcomeTagline;

  /// No description provided for @welcomeChipCountdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get welcomeChipCountdown;

  /// No description provided for @welcomeSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'What you\'ll see'**
  String get welcomeSlide2Title;

  /// No description provided for @welcomeSlide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything about every eclipse, just for your location.'**
  String get welcomeSlide2Subtitle;

  /// No description provided for @welcomeFeatureSolarBody.
  ///
  /// In en, this message translates to:
  /// **'Total, annular & partial — see type, path and countdown'**
  String get welcomeFeatureSolarBody;

  /// No description provided for @welcomeFeatureLunarBody.
  ///
  /// In en, this message translates to:
  /// **'Blood moon, penumbral & more — never miss a lunar event'**
  String get welcomeFeatureLunarBody;

  /// No description provided for @welcomeFeatureWeather.
  ///
  /// In en, this message translates to:
  /// **'Historical Weather'**
  String get welcomeFeatureWeather;

  /// No description provided for @welcomeFeatureWeatherBody.
  ///
  /// In en, this message translates to:
  /// **'See the weather forecast from last year on the eclipse date so you can plan ahead.'**
  String get welcomeFeatureWeatherBody;

  /// No description provided for @welcomeFeatureMap.
  ///
  /// In en, this message translates to:
  /// **'Eclipse Path Map'**
  String get welcomeFeatureMap;

  /// No description provided for @welcomeFeatureMapBody.
  ///
  /// In en, this message translates to:
  /// **'View the full path of totality on an interactive map.'**
  String get welcomeFeatureMapBody;

  /// No description provided for @welcomeSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Set your location'**
  String get welcomeSlide3Title;

  /// No description provided for @welcomeSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'EclipseAR needs your location to calculate eclipse visibility, type, and timing specifically for where you are.'**
  String get welcomeSlide3Body;

  /// No description provided for @welcomeUseGPS.
  ///
  /// In en, this message translates to:
  /// **'Use GPS'**
  String get welcomeUseGPS;

  /// No description provided for @welcomePickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick on Map'**
  String get welcomePickOnMap;

  /// No description provided for @welcomeSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get welcomeSkip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
