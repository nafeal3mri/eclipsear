import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eclipsear/l10n/app_localizations.dart';
import 'package:eclipsear/main.dart';
import 'package:eclipsear/aboutUs.dart';
import 'package:eclipsear/changeLocationMap.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _cityName     = '';
  String _languageCode = 'en';

  static const _bg = [
    Color(0xFF080604),
    Color(0xFF120E0A),
    Color(0xFF1A1510),
  ];
  static const _accent     = Color(0xFFC49A6C);
  static const _accentText = Color(0xFFD4A878);

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _cityName     = prefs.getString('cityname') ?? '';
      _languageCode = prefs.getString('language')  ?? 'en';
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _bg,
            stops: [0.0, 0.38, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildNavBar(context, loc),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [
                    // ── Location section
                    _sectionLabel(loc.location),
                    _tile(
                      icon:     Icons.location_on_rounded,
                      title:    loc.location,
                      subtitle: _cityName.isNotEmpty ? _cityName : '—',
                      onTap:    _showLocationSheet,
                    ),

                    const SizedBox(height: 20),

                    // ── Preferences section
                    _sectionLabel(loc.sectionPreferences),
                    _tile(
                      icon:     Icons.language_rounded,
                      title:    loc.language,
                      subtitle: _languageCode == 'ar' ? 'العربية' : 'English',
                      onTap:    _showLanguageSheet,
                    ),

                    const SizedBox(height: 20),

                    // ── App section
                    _sectionLabel(loc.sectionApp),
                    _tile(
                      icon:     Icons.favorite_rounded,
                      title:    loc.aboutus,
                      subtitle: loc.learnaboutus,
                      onTap:    () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AboutUsPage()),
                      ),
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

  // ── Nav bar ────────────────────────────────────────────────────────────────

  Widget _buildNavBar(BuildContext context, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white.withOpacity(0.80),
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            loc.settings,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared widgets ─────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: _accentText.withOpacity(0.50),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withOpacity(0.055),
              border: Border.all(
                color: Colors.white.withOpacity(0.09),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                // Icon pill
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accent.withOpacity(0.15),
                    border: Border.all(
                      color: _accent.withOpacity(0.30),
                      width: 0.8,
                    ),
                  ),
                  child: Icon(icon, color: _accentText, size: 18),
                ),
                const SizedBox(width: 14),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron
                Icon(
                  isRTL
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.28),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Bottom sheets ──────────────────────────────────────────────────────────

  void _showLocationSheet() {
    final loc = AppLocalizations.of(context)!;
    _showSheet(
      children: [
        _sheetOption(
          icon:  Icons.map_rounded,
          label: loc.selectFromMap,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChangeLocationPage()),
            ).then((_) => _loadPrefs());
          },
        ),
      ],
    );
  }

  void _showLanguageSheet() {
    _showSheet(
      children: [
        _sheetOption(
          label:   'العربية',
          leading: const Text('AR',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
          onTap: () {
            Navigator.pop(context);
            _setLanguage('ar');
          },
        ),
        _sheetOption(
          label:   'English',
          leading: const Text('EN',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
          onTap: () {
            Navigator.pop(context);
            _setLanguage('en');
          },
        ),
      ],
    );
  }

  void _showSheet({required List<Widget> children}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return ClipRRect(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              decoration: BoxDecoration(
                color: const Color(0xFF120E0A).withOpacity(0.95),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(
                    color: Colors.white.withOpacity(0.09), width: 0.7),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...children,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sheetOption({
    IconData? icon,
    Widget? leading,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.06),
          border:
              Border.all(color: Colors.white.withOpacity(0.08), width: 0.7),
        ),
        child: Row(
          children: [
            leading ??
                Icon(icon ?? Icons.circle, color: _accentText, size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // ── Logic ──────────────────────────────────────────────────────────────────

  Future<void> _setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    if (!mounted) return;
    setState(() => _languageCode = lang);
    EclipsearApp.of(context)
        ?.setLocale(Locale.fromSubtags(languageCode: lang));
  }
}
