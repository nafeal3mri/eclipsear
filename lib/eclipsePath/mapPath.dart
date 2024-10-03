import 'dart:convert';
import 'package:eclipsear/models/dateFormatter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SEmapPath {
  List<LatLng> topline = [];
  List<LatLng> centerpath = [];
  List<LatLng> bottommline = [];
  var centerMap = [];
  getEclipsePath() {}

  requestToPahts(date, {ecType = "solar"}) async {
    String city = '';
    String country = '';
    var formatteddate = DateFormatter()
        .getdatetimgformatted(false, date, dateFormat: "yyyyMMdd");
    var centerLine;
    var annularELine;
    var pathline2;
    var pathline3;
    var pathline4;
    var pathline5;
    var pathline6;
    List<dynamic> linedata = [];
    try {
      String eclipsetype = ecType + "_";

      String addpath = ecType == "lunar" ? "" : "_path";
      final response = await http.get(
        Uri.parse(
            'https://in-the-sky.org/news/eclipses/$eclipsetype$formatteddate$addpath.json'),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        final decodedResponse = json.decode(source);
        final resp = decodedResponse;
        List<LatLng> loc = [];
        List<LatLng> p1e = [];
        List<LatLng> p2e = [];
        List<LatLng> p3e = [];
        List<LatLng> p4e = [];
        List<LatLng> p5e = [];
        List<LatLng> p6e = [];
        if (ecType == "solar") {
          final mainpath = resp['path'].length > 0 ? resp['path'][0][1] : [];
          for (var element in mainpath) {
            loc.add(LatLng(element[2], element[1]));
          }
          for (var p1 in resp['contours'][0][1]) {
            p1e.add(LatLng(p1[1], p1[0]));
          }
          for (var p1 in resp['contours'][1][1]) {
            p2e.add(LatLng(p1[1], p1[0]));
          }
          for (var p1 in resp['contours'][2][1]) {
            p3e.add(LatLng(p1[1], p1[0]));
          }
          for (var p1 in resp['contours'][3][1]) {
            p4e.add(LatLng(p1[1], p1[0]));
          }
          for (var p1 in resp['contours'][4][1]) {
            p5e.add(LatLng(p1[1], p1[0]));
          }
          if (resp['contours'].length > 5) {
            for (var p6 in resp['contours'][5][1]) {
              p6e.add(LatLng(p6[1], p6[0]));
            }
          }
          linedata.add({'main': loc});
          linedata.add({'line1': p1e});
          linedata.add({'line2': p2e});
          linedata.add({'line3': p3e});
          linedata.add({'line4': p4e});
          linedata.add({'line5': p5e});
          linedata.add({'line6': p6e});
          // print(p6e);
        }else{
          
        }
      }
    } catch (e) {
      print('Error getting location data: $e');
    }
    return linedata;
  }
}
