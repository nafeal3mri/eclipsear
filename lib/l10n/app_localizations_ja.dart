// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String eclipseType(String eclipseType) {
    String _temp0 = intl.Intl.selectLogic(
      eclipseType,
      {
        'solarnotVisible': 'この場所では見えません',
        'solartotalEclipse': '皆既日食',
        'solarannularEclipse': '金環日食',
        'solarpartialEclipse': '部分日食',
        'lunarnotVisible': 'この場所では見えません',
        'lunartotalEclipse': '皆既月食',
        'lunarannularEclipse': '月食',
        'lunarpartialEclipse': '部分月食',
        'lunarpenumbralEclipse': '半影月食',
        'other': 'データなし',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => '日';

  @override
  String get year => '年';

  @override
  String get years => '年';

  @override
  String get month => '月';

  @override
  String get months => '月';

  @override
  String get viewMore => 'もっと見る';

  @override
  String get max => '最大';

  @override
  String get start => '開始';

  @override
  String get end => '終了';

  @override
  String get solarEclipse => '日食';

  @override
  String get lunarEclipse => '月食';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get location => '場所';

  @override
  String get setLocation => '場所を設定';

  @override
  String get selectFromMap => '地図から選択';

  @override
  String get selectFromList => '一覧から選択';

  @override
  String get eclipseDetails => '食の詳細';

  @override
  String get viewEclipseMap => '食の地図を見る';

  @override
  String get eclipsePath => '食の経路';

  @override
  String get eclipseSimulation => '食のシミュレーション';

  @override
  String ecVisibility(String EclipseVisibility) {
    String _temp0 = intl.Intl.selectLogic(
      EclipseVisibility,
      {
        'notVisibleShort': '見えない',
        'other': '見える',
      },
    );
    return '$_temp0';
  }

  @override
  String get visibility => '可視性';

  @override
  String get eclipseTypes => '食の種類';

  @override
  String get date => '日付';

  @override
  String get magnitude => '食分';

  @override
  String get coverage => 'カバー率';

  @override
  String get hours => '時間';

  @override
  String get minutes => '分';

  @override
  String get and => '&';

  @override
  String get douration => '継続時間';

  @override
  String get aboutus => 'EclipseAR について';

  @override
  String get learnaboutus => '私たちについて知りたいですか？';

  @override
  String get aboutuscontent =>
      'EclipseAR is a solar/lunar eclipse calender, some sources were used to make this app \n - NASA (https://eclipse.gsfc.nasa.gov) \n - © Dominic Ford (https://in-the-sky.org) \n This app DO NOT require any spicial permissions to your phone (Except Geolocation), it\'s optional, you can disable it whenever you want. \n If you interested to help translate this app to your language please contact me at info@nafe.me';

  @override
  String get eclipseended => '食は終了しました';

  @override
  String get solar => '日食';

  @override
  String get lunar => '月食';

  @override
  String get lastYearForecast => '昨年の天気';

  @override
  String get eclipseDiagram => '食の図';

  @override
  String get loadingEclipsePath => '食の経路を読み込み中…';

  @override
  String get loadingSimulation => 'シミュレーションを読み込み中…';

  @override
  String get diagramUnavailable => '図を表示できません';

  @override
  String get simulationUnavailable => 'この食のシミュレーションはありません';

  @override
  String get simulationAttribution => 'Simulation © Dominic Ford / in-the-sky.org';

  @override
  String get noUpcomingSolarEclipse => '今後の日食データがありません';

  @override
  String get noUpcomingLunarEclipse => '今後の月食データがありません';

  @override
  String get eclipseForecast => '食の予測';

  @override
  String get next10Years => '今後10年';

  @override
  String get noEclipsesInRange => '範囲内に食がありません';

  @override
  String get next => '次へ';

  @override
  String get past => '過去';

  @override
  String daysAbbr(Object count) => '${count}日';

  @override
  String monthsAbbr(Object count) => '${count}か月';

  @override
  String yearsAbbr(Object count) => '${count}年';

  @override
  String get nextEclipse => '次の食';

  @override
  String get seeDetails => '詳細を見る';

  @override
  String get upcomingEclipses => '今後の食';

  @override
  String get hrs => '時間';

  @override
  String get mins => '分';

  @override
  String get secs => '秒';

  @override
  String get sectionPreferences => '設定';

  @override
  String get sectionApp => 'アプリ';

  @override
  String get pleaseSelectLocation => '場所を選択してください';

  @override
  String get tapAnywhereOnMap => '地図上の任意の場所をタップしてください';

  @override
  String get eclipseNotVisible => 'この食はこの場所から見えません';

  @override
  String get eclipseAlreadyPassed => 'この食はすでに過ぎました';

  @override
  String get reminderSet => 'リマインダーを設定しました。食の前に通知します';

  @override
  String get sharedViaEclipsear => 'EclipseAR から共有';

  @override
  String get typeTotal => '皆既';

  @override
  String get typeAnnular => '金環';

  @override
  String get typePartial => '部分';

  @override
  String get typePenumbral => '半影';

  @override
  String get typeNotVisible => '見えない';

  @override
  String get welcomeTagline => '地球上のすべての日食・月食のパーソナルガイド';

  @override
  String get welcomeChipCountdown => 'カウントダウン';

  @override
  String get welcomeSlide2Title => '見られる内容';

  @override
  String get welcomeSlide2Subtitle => 'すべての食の情報を、あなたの場所に合わせて。';

  @override
  String get welcomeFeatureSolarBody => '皆既・金環・部分 — 種類、経路、カウントダウン';

  @override
  String get welcomeFeatureLunarBody => 'ブラッドムーンや半影など — 月のイベントを見逃さない';

  @override
  String get welcomeFeatureWeather => '過去の天気';

  @override
  String get welcomeFeatureWeatherBody => '食の日の昨年の天気を確認して計画できます。';

  @override
  String get welcomeFeatureMap => '食の経路マップ';

  @override
  String get welcomeFeatureMapBody =>
      '皆既帯の経路をインタラクティブな地図で確認できます。';

  @override
  String get welcomeSlide3Title => '場所を設定';

  @override
  String get welcomeSlide3Body =>
      'EclipseAR は、あなたの場所に基づいて可視性、種類、時刻を計算します。';

  @override
  String get welcomeUseGPS => 'GPS を使用';

  @override
  String get welcomePickOnMap => '地図で選ぶ';

  @override
  String get welcomeSkip => '今はスキップ';

  @override
  String get addReminder => 'リマインダーを追加';

  @override
  String get share => '共有';
}

