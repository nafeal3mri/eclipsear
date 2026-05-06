// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String eclipseType(String eclipseType) {
    String _temp0 = intl.Intl.selectLogic(
      eclipseType,
      {
        'solarnotVisible': '在你的位置不可见',
        'solartotalEclipse': '日全食',
        'solarannularEclipse': '日环食',
        'solarpartialEclipse': '日偏食',
        'lunarnotVisible': '在你的位置不可见',
        'lunartotalEclipse': '月全食',
        'lunarannularEclipse': '月环食',
        'lunarpartialEclipse': '月偏食',
        'lunarpenumbralEclipse': '半影月食',
        'other': '无数据',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => '天';

  @override
  String get year => '年';

  @override
  String get years => '年';

  @override
  String get month => '月';

  @override
  String get months => '月';

  @override
  String get viewMore => '查看更多';

  @override
  String get max => '最大';

  @override
  String get start => '开始';

  @override
  String get end => '结束';

  @override
  String get solarEclipse => '日食';

  @override
  String get lunarEclipse => '月食';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get location => '位置';

  @override
  String get setLocation => '设置位置';

  @override
  String get selectFromMap => '从地图选择';

  @override
  String get selectFromList => '从列表选择';

  @override
  String get eclipseDetails => '日食/月食详情';

  @override
  String get viewEclipseMap => '查看日食路径地图';

  @override
  String get eclipsePath => '日食路径';

  @override
  String get eclipseSimulation => '日食模拟';

  @override
  String ecVisibility(String EclipseVisibility) {
    String _temp0 = intl.Intl.selectLogic(
      EclipseVisibility,
      {
        'notVisibleShort': '不可见',
        'other': '可见',
      },
    );
    return '$_temp0';
  }

  @override
  String get visibility => '可见性';

  @override
  String get eclipseTypes => '日食类型';

  @override
  String get date => '日期';

  @override
  String get magnitude => '食分';

  @override
  String get coverage => '覆盖';

  @override
  String get hours => '小时';

  @override
  String get minutes => '分钟';

  @override
  String get and => '&';

  @override
  String get douration => '持续时间';

  @override
  String get aboutus => '关于 EclipseAR';

  @override
  String get learnaboutus => '想了解我们吗？';

  @override
  String get aboutuscontent =>
      'EclipseAR is a solar/lunar eclipse calender, some sources were used to make this app \n - NASA (https://eclipse.gsfc.nasa.gov) \n - © Dominic Ford (https://in-the-sky.org) \n This app DO NOT require any spicial permissions to your phone (Except Geolocation), it\'s optional, you can disable it whenever you want. \n If you interested to help translate this app to your language please contact me at info@nafe.me';

  @override
  String get eclipseended => '日食已结束';

  @override
  String get solar => '日食';

  @override
  String get lunar => '月食';

  @override
  String get lastYearForecast => '去年天气';

  @override
  String get eclipseDiagram => '示意图';

  @override
  String get loadingEclipsePath => '正在加载日食路径…';

  @override
  String get loadingSimulation => '正在加载模拟…';

  @override
  String get diagramUnavailable => '示意图不可用';

  @override
  String get simulationUnavailable => '此日食无模拟';

  @override
  String get simulationAttribution => '模拟 © Dominic Ford / in-the-sky.org';

  @override
  String get noUpcomingSolarEclipse => '没有即将到来的日食数据';

  @override
  String get noUpcomingLunarEclipse => '没有即将到来的月食数据';

  @override
  String get eclipseForecast => '日食预测';

  @override
  String get next10Years => '未来 10 年';

  @override
  String get noEclipsesInRange => '该范围内无日食';

  @override
  String get next => '下一次';

  @override
  String get past => '过去';

  @override
  String daysAbbr(Object count) {
    return '$count 天';
  }

  @override
  String monthsAbbr(Object count) {
    return '$count 月';
  }

  @override
  String yearsAbbr(Object count) {
    return '$count 年';
  }

  @override
  String get nextEclipse => '下一次日食';

  @override
  String get seeDetails => '查看详情';

  @override
  String get upcomingEclipses => '即将到来的日食';

  @override
  String get hrs => '小时';

  @override
  String get mins => '分钟';

  @override
  String get secs => '秒';

  @override
  String get sectionPreferences => '偏好设置';

  @override
  String get sectionApp => '应用';

  @override
  String get pleaseSelectLocation => '请选择一个位置';

  @override
  String get tapAnywhereOnMap => '点击地图上的任意位置';

  @override
  String get eclipseNotVisible => '此日食在你的位置不可见';

  @override
  String get eclipseAlreadyPassed => '此日食已经过去';

  @override
  String get reminderSet => '已设置提醒！你将在日食前收到通知';

  @override
  String get sharedViaEclipsear => '通过 EclipseAR 分享';

  @override
  String get typeTotal => '全食';

  @override
  String get typeAnnular => '环食';

  @override
  String get typePartial => '偏食';

  @override
  String get typePenumbral => '半影';

  @override
  String get typeNotVisible => '不可见';

  @override
  String get welcomeTagline => '选择语言';

  @override
  String get welcomeChipCountdown => '倒计时';

  @override
  String get welcomeSlide2Title => '你将看到什么';

  @override
  String get welcomeSlide2Subtitle => '关于每一次日食的一切，专为你的位置。';

  @override
  String get welcomeFeatureSolarBody => '全食、环食、偏食 — 类型、路径与倒计时';

  @override
  String get welcomeFeatureLunarBody => '血月、半影等 — 不错过任何月食';

  @override
  String get welcomeFeatureWeather => '历史天气';

  @override
  String get welcomeFeatureWeatherBody => '查看去年日食当天的天气，方便提前计划。';

  @override
  String get welcomeFeatureMap => '日食路径地图';

  @override
  String get welcomeFeatureMapBody => '在交互式地图上查看全食带路径。';

  @override
  String get welcomeSlide3Title => '设置你的位置';

  @override
  String get welcomeSlide3Body => 'EclipseAR 需要你的位置来计算可见性、类型和时间。';

  @override
  String get welcomeUseGPS => '使用 GPS';

  @override
  String get welcomePickOnMap => '在地图选择';

  @override
  String get welcomeSkip => '暂时跳过';

  @override
  String get addReminder => '添加提醒';

  @override
  String get share => '分享';
}
