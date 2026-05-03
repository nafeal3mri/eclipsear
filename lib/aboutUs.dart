import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eclipsear/l10n/app_localizations.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  static const _bg = [
    Color(0xFF080604),
    Color(0xFF120E0A),
    Color(0xFF1A1510),
  ];
  static const _accent     = Color(0xFFC49A6C);
  static const _accentText = Color(0xFFD4A878);

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: Column(
                    children: [
                      _buildHero(),
                      const SizedBox(height: 24),
                      _buildCard(
                        icon:  Icons.info_outline_rounded,
                        title: 'About the App',
                        child: _bodyText(
                          'EclipseAR is a solar & lunar eclipse calendar that '
                          'calculates upcoming eclipse events for your exact '
                          'location, shows countdowns, eclipse paths, and '
                          'historical weather on eclipse dates.',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCard(
                        icon:  Icons.science_outlined,
                        title: 'Data Sources',
                        child: Column(
                          children: [
                            _sourceRow(
                              label: 'NASA Eclipse Science',
                              url:   'eclipse.gsfc.nasa.gov',
                              icon:  Icons.public_rounded,
                            ),
                            const SizedBox(height: 10),
                            _sourceRow(
                              label: '© Dominic Ford',
                              url:   'in-the-sky.org',
                              icon:  Icons.public_rounded,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCard(
                        icon:  Icons.shield_outlined,
                        title: 'Privacy',
                        child: _bodyText(
                          'EclipseAR does not require any special permissions. '
                          'Geolocation is optional — you can set or change your '
                          'location manually at any time, or disable it entirely.',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCard(
                        icon:  Icons.translate_rounded,
                        title: 'Contribute',
                        child: _bodyText(
                          'Interested in translating EclipseAR into your '
                          'language? We\'d love your help!',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCard(
                        icon:  Icons.mail_outline_rounded,
                        title: 'Contact',
                        child: _contactRow('info@nafe.me'),
                      ),
                      const SizedBox(height: 24),
                      _buildVersionBadge(),
                    ],
                  ),
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
            loc.aboutus,
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

  // ── Hero ───────────────────────────────────────────────────────────────────

  Widget _buildHero() {
    return Column(
      children: [
        // Eclipse icon with glow
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _accent.withOpacity(0.10),
            border: Border.all(
              color: _accent.withOpacity(0.22),
              width: 0.9,
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.28),
                blurRadius: 36,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SvgPicture.asset(
              'assets/svg/solar_partial.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // App name
        Text(
          'EclipseAR',
          style: TextStyle(
            color: Colors.white.withOpacity(0.92),
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Solar & Lunar Eclipse Calendar',
          style: TextStyle(
            color: _accentText.withOpacity(0.60),
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ── Section card ───────────────────────────────────────────────────────────

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.055),
            border: Border.all(
              color: Colors.white.withOpacity(0.09),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _accent.withOpacity(0.14),
                      border: Border.all(
                        color: _accent.withOpacity(0.28),
                        width: 0.7,
                      ),
                    ),
                    child: Icon(icon, color: _accentText, size: 15),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.82),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Thin divider
              Divider(
                color: Colors.white.withOpacity(0.07),
                height: 1,
              ),
              const SizedBox(height: 12),

              child,
            ],
          ),
        ),
      ),
    );
  }

  // ── Widgets ────────────────────────────────────────────────────────────────

  Widget _bodyText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.60),
        fontSize: 13,
        height: 1.65,
      ),
    );
  }

  Widget _sourceRow({
    required String label,
    required String url,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _accent.withOpacity(0.10),
          ),
          child: Icon(icon, color: _accentText, size: 14),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              url,
              style: TextStyle(
                color: _accentText.withOpacity(0.55),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _contactRow(String email) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _accent.withOpacity(0.10),
          ),
          child: Icon(Icons.alternate_email_rounded,
              color: _accentText, size: 14),
        ),
        const SizedBox(width: 12),
        Text(
          email,
          style: TextStyle(
            color: _accentText,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildVersionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
          width: 0.7,
        ),
      ),
      child: Text(
        'Made with ❤️ by Nafe',
        style: TextStyle(
          color: Colors.white.withOpacity(0.28),
          fontSize: 12,
        ),
      ),
    );
  }
}
