import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' show utf8;

class GeoCoding {
  Future<Map<String, dynamic>> getCityFromLatlng(latitude, longitude) async {
    String city = '';
    String country = '';
    Map<String, dynamic> res = {};
    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude'),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        final decodedResponse = json.decode(source);

        final address = decodedResponse['address'];
        res = {
          'city': address['province'] ?? (address['city'] ?? address['state']),
          'country': address['country'] ?? ''
        };
      }
    } catch (e) {
      print('Error getting location data: $e');
    }
    return res;
  }

  Future<Map<String, dynamic>> getLatlngFromCity(cityname, country) async {
    String city = '';
    String country = '';
    Map<String, dynamic> res = {};
    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/search?city=$cityname&country=$country&format=json'),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        final decodedResponse = json.decode(source);
        // print(decodedResponse);
        final address = decodedResponse[0];
        res = {'lat': address['lat'], 'lon': address['lon']};
      }
    } catch (e) {
      print('Error getting location data: $e');
    }
    return res;
  }
}
