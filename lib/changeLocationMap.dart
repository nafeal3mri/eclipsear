import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eclipsear/models/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eclipsear/l10n/app_localizations.dart';
import 'package:eclipsear/main.dart';

class ChangeLocationPage extends StatefulWidget {
  const ChangeLocationPage({super.key});

  @override
  State<ChangeLocationPage> createState() => _ChangeLocationPageState();
}

class _ChangeLocationPageState extends State<ChangeLocationPage>
    with SingleTickerProviderStateMixin {
  final _mapController = MapController();

  LatLng? _selectedPoint;
  String  _country   = '';
  String  _city      = '';
  String  _cityName  = ''; // best display name persisted to prefs
  double  _latitude  = 0;
  double  _longitude = 0;
  double  _altitude  = 0;

  bool _geocoding    = false; // true while reverse-geocode is in flight
  bool _panelVisible = false;
  bool _saving       = false;

  // Slide-up animation for the confirmation panel
  late AnimationController _animCtrl;
  late Animation<Offset>   _slideAnim;

  static const _accent = Color(0xFFC49A6C);

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

    _loadSavedLocation();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat   = prefs.getDouble('latitude');
    final lon   = prefs.getDouble('longitude');
    if (lat != null && lon != null && mounted) {
      setState(() => _selectedPoint = LatLng(lat, lon));
      // Small delay so the map is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _mapController.move(LatLng(lat, lon), 5.0);
      });
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080604),
      body: Stack(
        children: [
          // ── Full-screen OpenStreetMap
          _buildMap(),

          // ── Nav bar overlay (top)
          SafeArea(
            child: Column(
              children: [
                _buildNavBar(),
                const Spacer(),
              ],
            ),
          ),

          // ── Slide-up confirmation panel (bottom)
          if (_panelVisible) _buildConfirmPanel(),
        ],
      ),
    );
  }

  // ── Map ────────────────────────────────────────────────────────────────────

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(25, 45),
        initialZoom:   3.0,
        minZoom:       1.5,
        maxZoom:       18.0,
        onTap:         (_, latLng) => _handleTap(latLng),
      ),
      children: [
        // Dark CartoDB tiles
        TileLayer(
          urlTemplate:
              'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
          userAgentPackageName: 'me.nafe.eclipsear',
          maxZoom: 18,
        ),

        // Selected location marker
        if (_selectedPoint != null)
          MarkerLayer(
            markers: [
              Marker(
                point:  _selectedPoint!,
                width:  56,
                height: 56,
                child:  _LocationPin(color: _accent),
              ),
            ],
          ),

        // Attribution
        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution('© CartoDB  © OpenStreetMap'),
          ],
        ),
      ],
    );
  }

  // ── Top nav bar ────────────────────────────────────────────────────────────

  Widget _buildNavBar() {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFF080604).withOpacity(0.80),
              border: Border.all(
                color: Colors.white.withOpacity(0.09),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white.withOpacity(0.80),
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.location,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Tap anywhere on the map',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.38),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Confirmation panel (slides up after tap) ───────────────────────────────

  Widget _buildConfirmPanel() {
    final loc = AppLocalizations.of(context)!;

    return Positioned(
      left:   0,
      right:  0,
      bottom: 0,
      child: SlideTransition(
        position: _slideAnim,
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24, 20, 24,
                MediaQuery.of(context).padding.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF120E0A).withOpacity(0.96),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.09),
                    width: 0.8,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Location pin icon
                  Icon(Icons.location_on_rounded, color: _accent, size: 28),
                  const SizedBox(height: 10),

                  // City + Country name (or spinner while geocoding)
                  if (_geocoding)
                    SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.8,
                        color: _accent.withOpacity(0.70),
                      ),
                    )
                  else ...[
                    if (_city.isNotEmpty)
                      AutoSizeText(
                        _city,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        maxFontSize: 22,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    if (_country.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      AutoSizeText(
                        _country,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        maxFontSize: 14,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.50),
                          fontSize: 14,
                        ),
                      ),
                    ],
                    if (_city.isEmpty && _country.isEmpty)
                      Text(
                        '${_latitude.toStringAsFixed(4)}, '
                        '${_longitude.toStringAsFixed(4)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 13,
                        ),
                      ),
                  ],
                  const SizedBox(height: 20),

                  // Set Location button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (_saving || _geocoding) ? null : _saveLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _accent.withOpacity(0.40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              loc.setLocation,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  Future<void> _handleTap(LatLng point) async {
    setState(() {
      _selectedPoint = point;
      _latitude      = point.latitude;
      _longitude     = point.longitude;
      _country       = '';
      _city          = '';
      _cityName      = '';
      _geocoding     = true;
      _panelVisible  = true;
    });
    _animCtrl.forward(from: 0);
    _mapController.move(LatLng(point.latitude, point.longitude), 7.0);

    // Reverse geocode — build the best display name regardless of result
    try {
      final geo = await GeoCoding()
          .getCityFromLatlng(point.latitude, point.longitude);
      if (!mounted) return;

      final country = geo['country'] as String? ?? '';
      final city    = geo['city']    as String? ?? '';

      // "City, Country" → "Country" → "lat, lon"
      final name = city.isNotEmpty
          ? (country.isNotEmpty ? '$city, $country' : city)
          : country.isNotEmpty
              ? country
              : '${point.latitude.toStringAsFixed(3)}, '
                '${point.longitude.toStringAsFixed(3)}';

      setState(() {
        _country   = country;
        _city      = city;
        _cityName  = name;
        _geocoding = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cityName  =
            '${point.latitude.toStringAsFixed(3)}, '
            '${point.longitude.toStringAsFixed(3)}';
        _geocoding = false;
      });
    }
  }

  /// Persists all location data and navigates back to the root.
  Future<void> _saveLocation() async {
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('latitude',       _latitude);
    await prefs.setDouble('longitude',      _longitude);
    await prefs.setDouble('altitude',       _altitude);
    await prefs.setString('cityname',       _cityName);
    // Mark as manually selected so GPS won't override it
    await prefs.setString('location_source', 'manual');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => EclipsearApp(
          userLanguage:   Locale(prefs.getString('language') ?? 'en'),
          isFirstLaunch:  false,
        ),
      ),
      (_) => false,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Custom pin widget
// ─────────────────────────────────────────────────────────────────────────────

class _LocationPin extends StatelessWidget {
  final Color color;
  const _LocationPin({required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.50),
                blurRadius: 14,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.my_location_rounded,
              color: Colors.white, size: 18),
        ),
        // Stem
        Container(
          width: 2,
          height: 10,
          color: color,
        ),
      ],
    );
  }
}
