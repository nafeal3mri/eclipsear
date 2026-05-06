// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String eclipseType(String eclipseType) {
    String _temp0 = intl.Intl.selectLogic(
      eclipseType,
      {
        'solarnotVisible': 'No visible en tu ubicación',
        'solartotalEclipse': 'Eclipse solar total',
        'solarannularEclipse': 'Eclipse solar anular',
        'solarpartialEclipse': 'Eclipse solar parcial',
        'lunarnotVisible': 'No visible en tu ubicación',
        'lunartotalEclipse': 'Eclipse lunar total',
        'lunarannularEclipse': 'Eclipse lunar anular',
        'lunarpartialEclipse': 'Eclipse lunar parcial',
        'lunarpenumbralEclipse': 'Eclipse lunar penumbral',
        'other': 'Sin datos',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => 'Días';

  @override
  String get year => 'Año';

  @override
  String get years => 'Años';

  @override
  String get month => 'Mes';

  @override
  String get months => 'Meses';

  @override
  String get viewMore => 'Ver más';

  @override
  String get max => 'Máx';

  @override
  String get start => 'Inicio';

  @override
  String get end => 'Fin';

  @override
  String get solarEclipse => 'Eclipse solar';

  @override
  String get lunarEclipse => 'Eclipse lunar';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get location => 'Ubicación';

  @override
  String get setLocation => 'Establecer ubicación';

  @override
  String get selectFromMap => 'Seleccionar en el mapa';

  @override
  String get selectFromList => 'Seleccionar de la lista';

  @override
  String get eclipseDetails => 'Detalles del eclipse';

  @override
  String get viewEclipseMap => 'Ver mapa del eclipse';

  @override
  String get eclipsePath => 'Trayectoria del eclipse';

  @override
  String get eclipseSimulation => 'Simulación del eclipse';

  @override
  String ecVisibility(String EclipseVisibility) {
    String _temp0 = intl.Intl.selectLogic(
      EclipseVisibility,
      {
        'notVisibleShort': 'No visible',
        'other': 'Visible',
      },
    );
    return '$_temp0';
  }

  @override
  String get visibility => 'Visibilidad';

  @override
  String get eclipseTypes => 'Tipo de eclipse';

  @override
  String get date => 'Fecha';

  @override
  String get magnitude => 'Magnitud';

  @override
  String get coverage => 'Cobertura';

  @override
  String get hours => 'Horas';

  @override
  String get minutes => 'Minutos';

  @override
  String get and => '&';

  @override
  String get douration => 'Duración';

  @override
  String get aboutus => 'Acerca de EclipseAR';

  @override
  String get learnaboutus => '¿Quieres saber sobre nosotros?';

  @override
  String get aboutuscontent =>
      'EclipseAR is a solar/lunar eclipse calender, some sources were used to make this app \n - NASA (https://eclipse.gsfc.nasa.gov) \n - © Dominic Ford (https://in-the-sky.org) \n This app DO NOT require any spicial permissions to your phone (Except Geolocation), it\'s optional, you can disable it whenever you want. \n If you interested to help translate this app to your language please contact me at info@nafe.me';

  @override
  String get eclipseended => 'Eclipse finalizado';

  @override
  String get solar => 'Solar';

  @override
  String get lunar => 'Lunar';

  @override
  String get lastYearForecast => 'Pronóstico del año pasado';

  @override
  String get eclipseDiagram => 'Diagrama del eclipse';

  @override
  String get loadingEclipsePath => 'Cargando trayectoria del eclipse…';

  @override
  String get loadingSimulation => 'Cargando simulación…';

  @override
  String get diagramUnavailable => 'Diagrama no disponible';

  @override
  String get simulationUnavailable =>
      'La simulación no está disponible para este eclipse';

  @override
  String get simulationAttribution =>
      'Simulación © Dominic Ford / in-the-sky.org';

  @override
  String get noUpcomingSolarEclipse =>
      'No hay datos de próximos eclipses solares';

  @override
  String get noUpcomingLunarEclipse =>
      'No hay datos de próximos eclipses lunares';

  @override
  String get eclipseForecast => 'Pronóstico del eclipse';

  @override
  String get next10Years => 'Próximos 10 años';

  @override
  String get noEclipsesInRange => 'No hay eclipses en este rango';

  @override
  String get next => 'PRÓXIMO';

  @override
  String get past => 'Pasado';

  @override
  String daysAbbr(Object count) {
    return '$count d';
  }

  @override
  String monthsAbbr(Object count) {
    return '$count m';
  }

  @override
  String yearsAbbr(Object count) {
    return '$count a';
  }

  @override
  String get nextEclipse => 'PRÓXIMO ECLIPSE';

  @override
  String get seeDetails => 'Ver detalles';

  @override
  String get upcomingEclipses => 'Próximos eclipses';

  @override
  String get hrs => 'H';

  @override
  String get mins => 'MIN';

  @override
  String get secs => 'SEG';

  @override
  String get sectionPreferences => 'Preferencias';

  @override
  String get sectionApp => 'Aplicación';

  @override
  String get pleaseSelectLocation => 'Por favor selecciona una ubicación';

  @override
  String get tapAnywhereOnMap => 'Toca en cualquier lugar del mapa';

  @override
  String get eclipseNotVisible =>
      'Este eclipse no es visible desde tu ubicación';

  @override
  String get eclipseAlreadyPassed => 'Este eclipse ya ha pasado';

  @override
  String get reminderSet =>
      '¡Recordatorio activado! Recibirás una notificación antes del eclipse';

  @override
  String get sharedViaEclipsear => 'Compartido vía EclipseAR';

  @override
  String get typeTotal => 'Total';

  @override
  String get typeAnnular => 'Anular';

  @override
  String get typePartial => 'Parcial';

  @override
  String get typePenumbral => 'Penumbral';

  @override
  String get typeNotVisible => 'No visible';

  @override
  String get welcomeTagline => 'Seleccionar idioma';

  @override
  String get welcomeChipCountdown => 'Cuenta regresiva';

  @override
  String get welcomeSlide2Title => 'Lo que verás';

  @override
  String get welcomeSlide2Subtitle =>
      'Todo sobre cada eclipse, solo para tu ubicación.';

  @override
  String get welcomeFeatureSolarBody =>
      'Total, anular y parcial — tipo, trayectoria y cuenta regresiva';

  @override
  String get welcomeFeatureLunarBody =>
      'Luna de sangre, penumbral y más — no te pierdas ningún evento lunar';

  @override
  String get welcomeFeatureWeather => 'Clima histórico';

  @override
  String get welcomeFeatureWeatherBody =>
      'Consulta el pronóstico del año pasado en la fecha del eclipse para planificar.';

  @override
  String get welcomeFeatureMap => 'Mapa de la trayectoria';

  @override
  String get welcomeFeatureMapBody =>
      'Ver la trayectoria completa de la totalidad en un mapa interactivo.';

  @override
  String get welcomeSlide3Title => 'Establece tu ubicación';

  @override
  String get welcomeSlide3Body =>
      'EclipseAR necesita tu ubicación para calcular visibilidad, tipo y horarios del eclipse para donde estás.';

  @override
  String get welcomeUseGPS => 'Usar GPS';

  @override
  String get welcomePickOnMap => 'Elegir en el mapa';

  @override
  String get welcomeSkip => 'Saltar por ahora';

  @override
  String get addReminder => 'Agregar recordatorio';

  @override
  String get share => 'Compartir';
}
