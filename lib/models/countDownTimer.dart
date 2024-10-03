import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate;

  CountdownTimer({required this.targetDate});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _duration = widget.targetDate.difference(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _duration = widget.targetDate.difference(DateTime.now());
      });

      if (_duration.inSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // String month = twoDigits(duration.inDays.remainder(7));
    double days_in_year = 365.25;
    double days_in_month = 30.4375;
    bool calc_years = duration.inDays > days_in_year ? true : false;
    int days = duration.inDays;
    int years = (days/days_in_year).toInt();
    int months = ((days%days_in_year)/days_in_month).toInt();
    int daysinmonth = ((days%days_in_month)).toInt();
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String daysSTR = AppLocalizations.of(context)!.days;
    String yearsSTR = years > 1 ? AppLocalizations.of(context)!.years : AppLocalizations.of(context)!.year;
    String monthsSTR = months > 1 ? AppLocalizations.of(context)!.months : AppLocalizations.of(context)!.month;
    String monthres = months > 0 ? "$months $monthsSTR" : "";
    if(days < 0){
      return AppLocalizations.of(context)!.eclipseended;
    }
    if(calc_years){
      return "$years $yearsSTR $monthres";
    }else{
      if(days > 50){
        return "$months $monthsSTR $daysinmonth $daysSTR";
      }
      return "$days $daysSTR $hours:$minutes:$seconds";
    }
    // return '$dayscond $days_left $timer_string';
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      _formatDuration(_duration),
      style: TextStyle(fontSize: 20,color: Colors.white),
      maxFontSize: 25,
      minFontSize: 15,
      maxLines: 2,
    );
  }
}
