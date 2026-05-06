import 'package:flutter/material.dart';
import 'package:eclipsear/l10n/app_localizations.dart';
import 'package:eclipsear/models/calc/eclipseCalc.dart';
import 'package:eclipsear/models/calc/lunareclipseCalc.dart';
import 'package:eclipsear/const/eclipse_theme.dart';
import 'package:eclipsear/pages/solar_page.dart';
import 'package:eclipsear/pages/lunar_page.dart';
import 'package:eclipsear/services/notification_service.dart';
import 'package:eclipsear/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:eclipsear/models/geocoding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  final _calcSolar = CalculateSolarEclipse();
  final _calcLunar = CalculateLunarEclipse();

  List<dynamic> _solarData = [];
  List<dynamic> _lunarData = [];

  dynamic _nextSolar;
  dynamic _nextLunar;

  String _userCity = '';
  double _userLat  = 0.0;
  double _userLon  = 0.0;

  bool _isLoading = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadEclipseData();
    _tryRefreshLocation();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadEclipseData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat  = prefs.getDouble('latitude')  ?? 0.0;
      final lon  = prefs.getDouble('longitude') ?? 0.0;
      final alt  = prefs.getDouble('altitude')  ?? 0.0;
      final city = prefs.getString('cityname')   ?? '';

      final solarData = _calcSolar.calculatefor(lat, lon, alt);
      final lunarData = _calcLunar.calculatefor(lat, lon, alt);
      final now = DateTime.now();

      final nextSolar = solarData.cast<dynamic>().firstWhere(
        (e) => DateTime.parse(e['DateTime']).isAfter(now),
        orElse: () => solarData.isNotEmpty ? solarData.last : null,
      );
      final nextLunar = lunarData.cast<dynamic>().firstWhere(
        (e) => DateTime.parse(e['DateTime']).isAfter(now),
        orElse: () => lunarData.isNotEmpty ? lunarData.last : null,
      );

      if (!mounted) return;
      setState(() {
        _solarData = solarData;
        _lunarData = lunarData;
        _nextSolar = nextSolar;
        _nextLunar = nextLunar;
        _userCity  = city;
        _userLat   = lat;
        _userLon   = lon;
        _isLoading = false;
      });

      NotificationService.scheduleEclipseNotifications(
        nextSolar: nextSolar,
        nextLunar: nextLunar,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _tryRefreshLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('location_source') == 'manual') return;

      final location = Location();

      bool svcEnabled = await location.serviceEnabled()
          .timeout(const Duration(seconds: 5), onTimeout: () => false);
      if (!svcEnabled) return;

      PermissionStatus perm = await location.hasPermission()
          .timeout(const Duration(seconds: 5), onTimeout: () => PermissionStatus.denied);
      if (perm == PermissionStatus.denied) {
        perm = await location.requestPermission()
            .timeout(const Duration(seconds: 15), onTimeout: () => PermissionStatus.denied);
      }
      if (perm != PermissionStatus.granted) return;

      final ld = await location.getLocation()
          .timeout(const Duration(seconds: 10));
      final lat = ld.latitude ?? 0;
      final lon = ld.longitude ?? 0;
      await prefs.setDouble('latitude',  lat);
      await prefs.setDouble('longitude', lon);
      await prefs.setDouble('altitude',  ld.altitude  ?? 0);
      await prefs.setString('location_source', 'gps');

      // Keep the UI city name in sync with GPS refresh.
      try {
        final geo = await GeoCoding().getCityFromLatlng(lat, lon);
        final country = geo['country'] as String? ?? '';
        final city = geo['city'] as String? ?? '';
        final displayName = city.isNotEmpty
            ? (country.isNotEmpty ? '$city, $country' : city)
            : country.isNotEmpty
                ? country
                : '${lat.toStringAsFixed(3)}, ${lon.toStringAsFixed(3)}';
        await prefs.setString('cityname', displayName);
      } catch (_) {}

      await _loadEclipseData();
    } catch (_) {}
  }

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SettingsPage()),
    );
    await _loadEclipseData();
  }

  EclipseTheme get _currentTheme {
    if (_currentPage == 0) {
      if (_nextSolar == null) return EclipseTheme.forSolar('notVisible', 0.0);
      return EclipseTheme.forSolar(
        _nextSolar['Type'] as String? ?? 'notVisible',
        EclipseTheme.parseMagnitude(_nextSolar['eclipseMg']),
      );
    } else {
      if (_nextLunar == null) return EclipseTheme.forLunar('notVisible', 0.0);
      return EclipseTheme.forLunar(
        _nextLunar['Type'] as String? ?? 'notVisible',
        EclipseTheme.parseMagnitude(_nextLunar['eclipseMg']),
      );
    }
  }

  void _switchPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF080604),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFC49A6C),
            strokeWidth: 2,
          ),
        ),
      );
    }

    final theme = _currentTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: theme.backgroundColors,
            stops: const [0.0, 0.38, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _BrandedTopBar(
                accentColor: theme.accentColor,
                onSettingsTap: _openSettings,
                userCity: _userCity,
              ),
              const SizedBox(height: 10),
              _SolarLunarToggle(
                currentPage: _currentPage,
                accentColor: theme.accentColor,
                onSwitch: _switchPage,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SolarPage(
                      allEclipses: _solarData,
                      nextEclipse: _nextSolar,
                      userLat:     _userLat,
                      userLon:     _userLon,
                      userCity:    _userCity,
                    ),
                    LunarPage(
                      allEclipses: _lunarData,
                      nextEclipse: _nextLunar,
                      userLat:     _userLat,
                      userLon:     _userLon,
                      userCity:    _userCity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BRANDED TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _BrandedTopBar extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onSettingsTap;
  final String userCity;

  const _BrandedTopBar({
    required this.accentColor,
    required this.onSettingsTap,
    required this.userCity,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final displayCity = userCity.isNotEmpty ? userCity : loc.pleaseSelectLocation;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 14, 0),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, color: accentColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayCity,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onSettingsTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
              child: Icon(
                Icons.settings_rounded,
                color: Colors.white.withOpacity(0.65),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SOLAR / LUNAR TOGGLE
// ─────────────────────────────────────────────────────────────────────────────

class _SolarLunarToggle extends StatelessWidget {
  final int currentPage;
  final Color accentColor;
  final ValueChanged<int> onSwitch;

  const _SolarLunarToggle({
    required this.currentPage,
    required this.accentColor,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            _togglePill(
              index: 0,
              icon: Icons.wb_sunny_rounded,
              label: loc.solar,
            ),
            _togglePill(
              index: 1,
              icon: Icons.nightlight_round,
              label: loc.lunar,
            ),
          ],
        ),
      ),
    );
  }

  Widget _togglePill({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = currentPage == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSwitch(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? accentColor.withOpacity(0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isActive
                  ? accentColor.withOpacity(0.40)
                  : Colors.transparent,
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive
                    ? Colors.white
                    : Colors.white.withOpacity(0.40),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : Colors.white.withOpacity(0.40),
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
