import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// WMO weather codes → icon + description.
/// Uses Material icons and theme-compatible colours instead of emoji,
/// so the weather card blends naturally with the deep-space design.
class WeatherCodeInfo {
  final IconData icon;
  final Color    iconColor;
  final String   description;
  const WeatherCodeInfo(this.icon, this.iconColor, this.description);
}

WeatherCodeInfo weatherCodeInfo(int code) {
  if (code == 0)  return const WeatherCodeInfo(Icons.wb_sunny_rounded,      Color(0xFFFFCC44), 'Clear sky');
  if (code <= 2)  return const WeatherCodeInfo(Icons.wb_cloudy_rounded,      Color(0xFF90B8D4), 'Partly cloudy');
  if (code == 3)  return const WeatherCodeInfo(Icons.cloud_rounded,          Color(0xFF7090AA), 'Overcast');
  if (code <= 48) return const WeatherCodeInfo(Icons.blur_on_rounded,        Color(0xFF8899AA), 'Foggy');
  if (code <= 57) return const WeatherCodeInfo(Icons.grain_rounded,          Color(0xFF70BBCC), 'Drizzle');
  if (code <= 67) return const WeatherCodeInfo(Icons.water_drop_rounded,     Color(0xFF5599CC), 'Rain');
  if (code <= 77) return const WeatherCodeInfo(Icons.ac_unit_rounded,        Color(0xFFBBDDFF), 'Snow');
  if (code <= 82) return const WeatherCodeInfo(Icons.water_drop_rounded,     Color(0xFF44AACC), 'Showers');
  if (code <= 86) return const WeatherCodeInfo(Icons.ac_unit_rounded,        Color(0xFFAADDFF), 'Snow showers');
  return                const WeatherCodeInfo(Icons.bolt_rounded,            Color(0xFF9988FF), 'Thunderstorm');
}

class HistoricalWeatherData {
  final double maxTempC;
  final double minTempC;
  final double precipitationMm;
  final int    weatherCode;

  const HistoricalWeatherData({
    required this.maxTempC,
    required this.minTempC,
    required this.precipitationMm,
    required this.weatherCode,
  });

  WeatherCodeInfo get info => weatherCodeInfo(weatherCode);

  String get tempRange =>
      '${maxTempC.round()}° / ${minTempC.round()}°';

  String get precipStr =>
      precipitationMm > 0
          ? '${precipitationMm.toStringAsFixed(1)} mm'
          : 'No rain';
}

/// Fetches historical daily weather from the Open-Meteo archive API.
/// [date] must be in "YYYY-MM-DD" format.
/// Returns null on error / no data.
Future<HistoricalWeatherData?> fetchHistoricalWeather({
  required double latitude,
  required double longitude,
  required String date,
}) async {
  try {
    final uri = Uri.parse(
      'https://archive-api.open-meteo.com/v1/archive'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&start_date=$date'
      '&end_date=$date'
      '&daily=temperature_2m_max,temperature_2m_min,weathercode,precipitation_sum'
      '&timezone=auto',
    );

    final response =
        await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) return null;

    final json   = jsonDecode(response.body) as Map<String, dynamic>;
    final daily  = json['daily'] as Map<String, dynamic>?;
    if (daily == null) return null;

    final maxList  = daily['temperature_2m_max']  as List?;
    final minList  = daily['temperature_2m_min']  as List?;
    final codeList = daily['weathercode']          as List?;
    final rainList = daily['precipitation_sum']    as List?;

    if (maxList == null || maxList.isEmpty) return null;

    return HistoricalWeatherData(
      maxTempC:        (maxList[0]  as num).toDouble(),
      minTempC:        (minList![0] as num).toDouble(),
      weatherCode:     (codeList![0] as num).toInt(),
      precipitationMm: (rainList![0] as num?)?.toDouble() ?? 0.0,
    );
  } catch (_) {
    return null;
  }
}

/// Given an eclipse date string ("YYYY-MM-DD"), returns the same date
/// one year earlier.
String lastYearDate(String eclipseDateStr) {
  try {
    final d    = DateTime.parse(eclipseDateStr);
    final prev = DateTime(d.year - 1, d.month, d.day);
    return '${prev.year}-'
        '${prev.month.toString().padLeft(2, '0')}-'
        '${prev.day.toString().padLeft(2, '0')}';
  } catch (_) {
    return eclipseDateStr;
  }
}

/// Friendly display form of a YYYY-MM-DD date, e.g. "Aug 12, 2025".
String friendlyDate(String yyyyMmDd) {
  try {
    final d      = DateTime.parse(yyyyMmDd);
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  } catch (_) {
    return yyyyMmDd;
  }
}
