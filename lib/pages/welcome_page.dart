import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:eclipsear/changeLocationMap.dart';
import 'package:eclipsear/pages/home_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  WELCOME / ONBOARDING PAGE
// ─────────────────────────────────────────────────────────────────────────────

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;

  // Location step
  bool _locLoading = false;
  String? _locError;

  // Entrance animation
  late AnimationController _fadeCtrl;
  late Animation<double>    _fadeAnim;

  // Icon pulse
  late AnimationController _pulseCtrl;
  late Animation<double>    _pulseAnim;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _goNext() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (_) => false,
    );
  }

  Future<void> _useGPS() async {
    setState(() { _locLoading = true; _locError = null; });

    try {
      final location = Location();

      bool svcEnabled = await location.serviceEnabled()
          .timeout(const Duration(seconds: 5), onTimeout: () => false);
      if (!svcEnabled) {
        svcEnabled = await location.requestService()
            .timeout(const Duration(seconds: 10), onTimeout: () => false);
      }
      if (!svcEnabled) {
        setState(() { _locLoading = false; _locError = 'Location services disabled'; });
        return;
      }

      PermissionStatus perm = await location.hasPermission()
          .timeout(const Duration(seconds: 5), onTimeout: () => PermissionStatus.denied);
      if (perm == PermissionStatus.denied) {
        perm = await location.requestPermission()
            .timeout(const Duration(seconds: 20), onTimeout: () => PermissionStatus.denied);
      }
      if (perm != PermissionStatus.granted) {
        setState(() { _locLoading = false; _locError = 'Location permission denied'; });
        return;
      }

      final ld = await location.getLocation()
          .timeout(const Duration(seconds: 12));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('latitude',  ld.latitude  ?? 0);
      await prefs.setDouble('longitude', ld.longitude ?? 0);
      await prefs.setDouble('altitude',  ld.altitude  ?? 0);
      await prefs.setString('location_source', 'gps');

      if (!mounted) return;
      _goToHome();
    } catch (_) {
      setState(() { _locLoading = false; _locError = 'Could not get location'; });
    }
  }

  void _pickOnMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChangeLocationPage()),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080604),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            // Starfield
            const Positioned.fill(child: _StarField()),

            // Page content
            PageView(
              controller:    _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              physics:       const BouncingScrollPhysics(),
              children: [
                _buildSlide1(),
                _buildSlide2(),
                _buildSlide3(),
              ],
            ),

            // Bottom: page dots + button
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Slide 1 — Welcome ──────────────────────────────────────────────────────

  Widget _buildSlide1() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 60),

          // Pulsing eclipse icon
          ScaleTransition(
            scale: _pulseAnim,
            child: _GlowIcon(
              asset:     'assets/svg/solar_partial.svg',
              size:      140,
              glowColor: const Color(0xFFA07850),
            ),
          ),

          const SizedBox(height: 36),

          const Text(
            'EclipseAR',
            style: TextStyle(
              color:      Color(0xFFD4A878),
              fontSize:   38,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Your personal guide to every\nsolar & lunar eclipse on Earth',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:    Colors.white.withOpacity(0.60),
                fontSize: 15,
                height:   1.5,
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Feature chips
          _FeatureRow(chips: const [
            _FeatureChip(icon: Icons.wb_sunny_rounded,     label: 'Solar Eclipses'),
            _FeatureChip(icon: Icons.nightlight_round,     label: 'Lunar Eclipses'),
            _FeatureChip(icon: Icons.timer_outlined,       label: 'Countdown'),
          ]),
        ],
      ),
    );
  }

  // ── Slide 2 — Features ────────────────────────────────────────────────────

  Widget _buildSlide2() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),

            Text(
              'What you\'ll see',
              style: TextStyle(
                color:      Colors.white.withOpacity(0.90),
                fontSize:   28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Everything about every eclipse,\njust for your location.',
              style: TextStyle(
                color:  Colors.white.withOpacity(0.45),
                fontSize: 14,
                height:   1.5,
              ),
            ),

            const SizedBox(height: 36),

            Row(
              children: [
                Expanded(
                  child: _FeatureCard(
                    asset:      'assets/svg/solar_annular.svg',
                    glowColor:  const Color(0xFFC49A6C),
                    title:      'Solar Eclipses',
                    body:       'Total, annular & partial — see type, path and countdown',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FeatureCard(
                    asset:      'assets/svg/lunar_total.svg',
                    glowColor:  const Color(0xFFBB7755),
                    title:      'Lunar Eclipses',
                    body:       'Blood moon, penumbral & more — never miss a lunar event',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _WideFeatureCard(
              iconData:  Icons.wb_cloudy_outlined,
              accentColor: const Color(0xFFB08860),
              title:     'Historical Weather',
              body:      'See the weather forecast from last year on the eclipse date so you can plan ahead.',
            ),

            const SizedBox(height: 16),

            _WideFeatureCard(
              iconData:  Icons.map_outlined,
              accentColor: const Color(0xFFA08878),
              title:     'Eclipse Path Map',
              body:      'View the full path of totality on an interactive map.',
            ),
          ],
        ),
      ),
    );
  }

  // ── Slide 3 — Location ────────────────────────────────────────────────────

  Widget _buildSlide3() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Location pin icon with glow
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC49A6C).withOpacity(0.12),
                border: Border.all(
                  color: const Color(0xFFC49A6C).withOpacity(0.30),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC49A6C).withOpacity(0.25),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Color(0xFFD4A878),
                size: 44,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Set your location',
              style: TextStyle(
                color:      Colors.white,
                fontSize:   26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              'EclipseAR needs your location to calculate\neclipse visibility, type, and timing\nspecifically for where you are.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:  Colors.white.withOpacity(0.50),
                fontSize: 14,
                height:   1.6,
              ),
            ),

            const SizedBox(height: 40),

            // GPS Button
            SizedBox(
              width: double.infinity,
              child: _PrimaryButton(
                label:    'Use GPS',
                icon:     Icons.gps_fixed_rounded,
                loading:  _locLoading,
                onTap:    _useGPS,
              ),
            ),

            const SizedBox(height: 12),

            // Map Button
            SizedBox(
              width: double.infinity,
              child: _SecondaryButton(
                label: 'Pick on Map',
                icon:  Icons.map_outlined,
                onTap: _pickOnMap,
              ),
            ),

            if (_locError != null) ...[
              const SizedBox(height: 14),
              Text(
                _locError!,
                style: TextStyle(
                  color:    Colors.redAccent.withOpacity(0.80),
                  fontSize: 12,
                ),
              ),
            ],

            const SizedBox(height: 18),

            // Skip
            GestureDetector(
              onTap: _goToHome,
              child: Text(
                'Skip for now',
                style: TextStyle(
                  color:    Colors.white.withOpacity(0.30),
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white.withOpacity(0.20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom bar: dots + next/done ──────────────────────────────────────────

  Widget _buildBottomBar() {
    final isLast = _currentPage == 2;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          color: Colors.black.withOpacity(0.30),
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 36),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Dots
              Row(
                children: List.generate(3, (i) {
                  final active = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 6),
                    width:  active ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFFD4A878)
                          : Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              // Next / hidden on last slide (buttons are inside slide 3)
              if (!isLast)
                GestureDetector(
                  onTap: _goNext,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
                    decoration: BoxDecoration(
                      color:        const Color(0xFFC49A6C).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFFC49A6C).withOpacity(0.40),
                        width: 0.9,
                      ),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          'Next',
                          style: TextStyle(
                            color:      Color(0xFFD4A878),
                            fontSize:   14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded,
                            color: Color(0xFFD4A878), size: 16),
                      ],
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  STAR FIELD PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarPainter(),
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng  = math.Random(42);
    final paint = Paint()..color = Colors.white;
    for (var i = 0; i < 160; i++) {
      final x    = rng.nextDouble() * size.width;
      final y    = rng.nextDouble() * size.height;
      final r    = rng.nextDouble() * 1.2 + 0.3;
      final opac = rng.nextDouble() * 0.55 + 0.10;
      paint.color = Colors.white.withOpacity(opac);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  GLOW ICON  (wraps any SVG asset with a bloom shadow)
// ─────────────────────────────────────────────────────────────────────────────

class _GlowIcon extends StatelessWidget {
  final String asset;
  final double size;
  final Color  glowColor;
  const _GlowIcon({required this.asset, required this.size, required this.glowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: glowColor.withOpacity(0.40), blurRadius: 60, spreadRadius: 8),
          BoxShadow(color: glowColor.withOpacity(0.18), blurRadius: 100, spreadRadius: 20),
        ],
      ),
      child: SvgPicture.asset(asset, width: size, height: size),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FEATURE ROW (Slide 1 chips)
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureChip {
  final IconData icon;
  final String   label;
  const _FeatureChip({required this.icon, required this.label});
}

class _FeatureRow extends StatelessWidget {
  final List<_FeatureChip> chips;
  const _FeatureRow({required this.chips});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment:   WrapAlignment.center,
      spacing:     10,
      runSpacing:  10,
      children: chips.map((c) => _chip(c)).toList(),
    );
  }

  Widget _chip(_FeatureChip c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color:        Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(c.icon, color: const Color(0xFFD4A878), size: 15),
          const SizedBox(width: 7),
          Text(
            c.label,
            style: TextStyle(
              color:    Colors.white.withOpacity(0.75),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FEATURE CARDS (Slide 2)
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureCard extends StatelessWidget {
  final String asset;
  final Color  glowColor;
  final String title;
  final String body;

  const _FeatureCard({
    required this.asset,
    required this.glowColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:        Colors.white.withOpacity(0.055),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: glowColor.withOpacity(0.22),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  shape:     BoxShape.circle,
                  color:     glowColor.withOpacity(0.12),
                  boxShadow: [BoxShadow(color: glowColor.withOpacity(0.28), blurRadius: 18)],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(asset, width: 28, height: 28),
                ),
              ),
              const SizedBox(height: 12),
              Text(title,
                style: TextStyle(
                  color:      Colors.white.withOpacity(0.90),
                  fontSize:   13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(body,
                style: TextStyle(
                  color:  Colors.white.withOpacity(0.40),
                  fontSize: 11,
                  height:   1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideFeatureCard extends StatelessWidget {
  final IconData iconData;
  final Color    accentColor;
  final String   title;
  final String   body;
  const _WideFeatureCard({
    required this.iconData,
    required this.accentColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:        Colors.white.withOpacity(0.045),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: accentColor.withOpacity(0.18),
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  shape:     BoxShape.circle,
                  color:     accentColor.withOpacity(0.12),
                  boxShadow: [BoxShadow(color: accentColor.withOpacity(0.25), blurRadius: 14)],
                ),
                child: Icon(iconData, color: accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      style: TextStyle(
                        color:      Colors.white.withOpacity(0.88),
                        fontSize:   13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(body,
                      style: TextStyle(
                        color:  Colors.white.withOpacity(0.40),
                        fontSize: 12,
                        height:   1.45,
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
}

// ─────────────────────────────────────────────────────────────────────────────
//  BUTTONS (Slide 3)
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String   label;
  final IconData icon;
  final bool     loading;
  final VoidCallback onTap;
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF9C7040), Color(0xFFC49A6C)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC49A6C).withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 9),
                    Text(
                      label,
                      style: const TextStyle(
                        color:      Colors.white,
                        fontSize:   15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String   label;
  final IconData icon;
  final VoidCallback onTap;
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color:        Colors.white.withOpacity(0.07),
          border: Border.all(
            color: Colors.white.withOpacity(0.18),
            width: 0.9,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.75), size: 18),
              const SizedBox(width: 9),
              Text(
                label,
                style: TextStyle(
                  color:      Colors.white.withOpacity(0.85),
                  fontSize:   15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
