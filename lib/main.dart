import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:eclipsear/l10n/app_localizations.dart';
import 'package:eclipsear/pages/home_page.dart';
import 'package:eclipsear/pages/welcome_page.dart';
import 'package:eclipsear/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  final prefs = await SharedPreferences.getInstance();

  Locale userLanguage;
  if (prefs.containsKey('language')) {
    userLanguage = Locale(prefs.getString('language') ?? 'en');
  } else {
    final systemLocale = Platform.localeName.toString();
    userLanguage = Locale(
      (systemLocale == 'ar' || systemLocale == 'en') ? systemLocale : 'en',
    );
  }

  // Show welcome screen on first launch (no stored location yet).
  final isFirstLaunch = !prefs.containsKey('latitude');

  runApp(EclipsearApp(userLanguage: userLanguage, isFirstLaunch: isFirstLaunch));
}

class EclipsearApp extends StatefulWidget {
  const EclipsearApp({
    super.key,
    required this.userLanguage,
    this.isFirstLaunch = false,
  });
  final Locale userLanguage;
  final bool   isFirstLaunch;

  @override
  State<EclipsearApp> createState() => _EclipsearAppState();

  /// Allow child widgets to change the locale at runtime (Settings page).
  static _EclipsearAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_EclipsearAppState>();
}

class _EclipsearAppState extends State<EclipsearApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.userLanguage;
  }

  void setLocale(Locale value) => setState(() => _locale = value);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eclipsear',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Dubai',
        scaffoldBackgroundColor: const Color(0xFF080604),
      ),
      home: widget.isFirstLaunch ? const WelcomePage() : const HomePage(),
    );
  }
}
