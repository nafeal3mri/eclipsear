import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

class TimeDifferenceCalculator extends StatelessWidget {
  final String time1Str;
  final String time2Str;
  const TimeDifferenceCalculator(
      {required this.time1Str, required this.time2Str});

  Widget calculateTimeDifference(h,m,sep) {
    // Parse the time strings into DateTime objects
    DateTime time1 = DateTime.parse(time1Str);
    DateTime time2 = DateTime.parse(time2Str);

    Duration difference = time2.difference(time1);
    
    return AutoSizeText(
        '${difference.inHours} $h $sep ${difference.inMinutes.remainder(60)} $m');
  }

  Widget build(BuildContext context) {
    String hoursstr = AppLocalizations.of(context)!.hours;
    String minsstr = AppLocalizations.of(context)!.minutes;
    String andstr = AppLocalizations.of(context)!.and;
    return calculateTimeDifference(hoursstr,minsstr,andstr); // An empty container serves as a blank widget
  }
}
