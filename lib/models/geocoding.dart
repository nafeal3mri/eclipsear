import 'package:http/http.dart' as http;
import 'dart:convert' show json, utf8;

/// Nominatim (OpenStreetMap) reverse & forward geocoding.
///
/// Nominatim usage policy requires a descriptive User-Agent header.
/// See: https://operations.osmfoundation.org/policies/nominatim/
class GeoCoding {
  static const _userAgent = 'Eclipsear/1.0 (me.nafe.eclipsear)';

  /// Returns { 'city': String, 'country': String } from lat/lon.
  /// Uses Nominatim reverse geocoding. Falls back through multiple
  /// address fields so rural/coastal locations still get a name.
  Future<Map<String, dynamic>> getCityFromLatlng(
    dynamic latitude,
    dynamic longitude,
  ) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=json'
        '&lat=$latitude'
        '&lon=$longitude'
        '&accept-language=en',
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return {};

      final decoded = json.decode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
      final address = decoded['address'] as Map<String, dynamic>? ?? {};

      // Nominatim returns different keys depending on the location type.
      // Walk through from most-specific to least-specific.
      final city = address['city']          as String? ??
                   address['town']          as String? ??
                   address['village']       as String? ??
                   address['municipality']  as String? ??
                   address['suburb']        as String? ??
                   address['county']        as String? ??
                   address['state_district']as String? ??
                   address['state']         as String? ??
                   address['province']      as String? ??
                   '';

      final country = address['country'] as String? ?? '';

      return {'city': city, 'country': country};
    } catch (e) {
      return {};
    }
  }

  /// Returns { 'lat': String, 'lon': String } from city + country name.
  Future<Map<String, dynamic>> getLatlngFromCity(
    dynamic cityname,
    dynamic country,
  ) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?city=$cityname'
        '&country=$country'
        '&format=json'
        '&accept-language=en'
        '&limit=1',
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return {};

      final decoded = json.decode(utf8.decode(response.bodyBytes)) as List;
      if (decoded.isEmpty) return {};

      final first = decoded[0] as Map<String, dynamic>;
      return {'lat': first['lat'], 'lon': first['lon']};
    } catch (e) {
      return {};
    }
  }
}
