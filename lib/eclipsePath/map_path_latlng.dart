import 'dart:convert';
import 'package:eclipsear/models/dateFormatter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Eclipse path polygons / center line returned as latlong2 LatLng,
/// ready for use with flutter_map.
class EclipsePathData {
  final List<LatLng> centerLine; // central path (total/annular strip)
  final List<LatLng> contour1;
  final List<LatLng> contour2;
  final List<LatLng> contour3;
  final List<LatLng> contour4;
  final List<LatLng> contour5;
  final List<LatLng> contour6;

  const EclipsePathData({
    required this.centerLine,
    required this.contour1,
    required this.contour2,
    required this.contour3,
    required this.contour4,
    required this.contour5,
    required this.contour6,
  });

  bool get hasData =>
      centerLine.isNotEmpty ||
      contour1.isNotEmpty ||
      contour2.isNotEmpty;

  static const empty = EclipsePathData(
    centerLine: [],
    contour1:   [],
    contour2:   [],
    contour3:   [],
    contour4:   [],
    contour5:   [],
    contour6:   [],
  );
}

/// Fetches the eclipse path JSON from in-the-sky.org and converts it
/// to [EclipsePathData] using latlong2 coordinates.
Future<EclipsePathData> fetchEclipsePath(
  String date, {
  String eclipseType = 'solar',
}) async {
  try {
    final fmt = DateFormatter()
        .getdatetimgformatted(false, date, dateFormat: 'yyyyMMdd');

    final suffix = eclipseType == 'lunar' ? '' : '_path';
    final url =
        'https://in-the-sky.org/news/eclipses/${eclipseType}_$fmt$suffix.json';

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) return EclipsePathData.empty;

    final decoded =
        json.decode(const Utf8Decoder().convert(response.bodyBytes));

    if (eclipseType != 'solar') return EclipsePathData.empty;

    List<LatLng> toList(List raw, {bool swapXY = false}) => raw
        .map<LatLng>((p) => swapXY
            ? LatLng((p[1] as num).toDouble(), (p[0] as num).toDouble())
            : LatLng((p[2] as num).toDouble(), (p[1] as num).toDouble()))
        .toList();

    final paths    = decoded['path']     as List? ?? [];
    final contours = decoded['contours'] as List? ?? [];

    final centerLine =
        paths.isNotEmpty ? toList(paths[0][1] as List) : <LatLng>[];

    List<LatLng> c(int i) => contours.length > i
        ? toList(contours[i][1] as List, swapXY: true)
        : <LatLng>[];

    return EclipsePathData(
      centerLine: centerLine,
      contour1:   c(0),
      contour2:   c(1),
      contour3:   c(2),
      contour4:   c(3),
      contour5:   c(4),
      contour6:   c(5),
    );
  } catch (_) {
    return EclipsePathData.empty;
  }
}
