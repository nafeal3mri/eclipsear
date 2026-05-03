import 'package:flutter/material.dart';

class EclipseTheme {
  final List<Color> backgroundColors;
  final Color accentColor;
  final Color glowColor;
  final Color textAccentColor;
  final Color cardBorderColor;
  final Color cardFillColor;

  const EclipseTheme({
    required this.backgroundColors,
    required this.accentColor,
    required this.glowColor,
    required this.textAccentColor,
    required this.cardBorderColor,
    required this.cardFillColor,
  });

  // ─── SOLAR ────────────────────────────────────────────────────────────────

  static EclipseTheme forSolar(String type, double magnitude) {
    switch (type) {
      case 'totalEclipse':
        return const EclipseTheme(
          backgroundColors: [Color(0xFF080503), Color(0xFF140E08), Color(0xFF1E150E)],
          accentColor:      Color(0xFFC49A6C),
          glowColor:        Color(0xFFA07850),
          textAccentColor:  Color(0xFFD4A878),
          cardBorderColor:  Color(0x44C49A6C),
          cardFillColor:    Color(0x14C49A6C),
        );

      case 'annularEclipse':
        return const EclipseTheme(
          backgroundColors: [Color(0xFF080503), Color(0xFF18100A), Color(0xFF261A0E)],
          accentColor:      Color(0xFFD4A050),
          glowColor:        Color(0xFFBB8C40),
          textAccentColor:  Color(0xFFE0B870),
          cardBorderColor:  Color(0x44D4A050),
          cardFillColor:    Color(0x14D4A050),
        );

      case 'partialEclipse':
        return _partialSolar(magnitude.clamp(0.0, 1.0));

      default: // notVisible
        return const EclipseTheme(
          backgroundColors: [Color(0xFF080604), Color(0xFF120E0A), Color(0xFF1A1510)],
          accentColor:      Color(0xFF9C8068),
          glowColor:        Color(0xFF7A6050),
          textAccentColor:  Color(0xFFB89880),
          cardBorderColor:  Color(0x449C8068),
          cardFillColor:    Color(0x149C8068),
        );
    }
  }

  static EclipseTheme _partialSolar(double t) {
    final bg0 = Color.lerp(const Color(0xFF080604), const Color(0xFF080503), t)!;
    final bg1 = Color.lerp(const Color(0xFF120E0A), const Color(0xFF140E08), t)!;
    final bg2 = Color.lerp(const Color(0xFF1A1510), const Color(0xFF1E150E), t)!;
    final accent = Color.lerp(const Color(0xFFB08860), const Color(0xFFC49A6C), t)!;
    final glow   = Color.lerp(const Color(0xFF906848), const Color(0xFFA07850), t)!;
    final text   = Color.lerp(const Color(0xFFC4A080), const Color(0xFFD4A878), t)!;
    return EclipseTheme(
      backgroundColors: [bg0, bg1, bg2],
      accentColor:      accent,
      glowColor:        glow,
      textAccentColor:  text,
      cardBorderColor:  accent.withOpacity(0.27),
      cardFillColor:    accent.withOpacity(0.08),
    );
  }

  // ─── LUNAR ────────────────────────────────────────────────────────────────

  static EclipseTheme forLunar(String type, double magnitude) {
    switch (type) {
      case 'totalEclipse':
        return const EclipseTheme(
          backgroundColors: [Color(0xFF080404), Color(0xFF140A08), Color(0xFF1E100C)],
          accentColor:      Color(0xFFBB7755),
          glowColor:        Color(0xFF995A40),
          textAccentColor:  Color(0xFFD09070),
          cardBorderColor:  Color(0x44BB7755),
          cardFillColor:    Color(0x14BB7755),
        );

      case 'partialEclipse':
        return const EclipseTheme(
          backgroundColors: [Color(0xFF080505), Color(0xFF140E0C), Color(0xFF1C1412)],
          accentColor:      Color(0xFFAA8870),
          glowColor:        Color(0xFF886850),
          textAccentColor:  Color(0xFFC4A088),
          cardBorderColor:  Color(0x44AA8870),
          cardFillColor:    Color(0x14AA8870),
        );

      case 'penumbralEclipse':
        return const EclipseTheme(
          backgroundColors: [Color(0xFF080606), Color(0xFF120E0C), Color(0xFF1A1412)],
          accentColor:      Color(0xFFA08878),
          glowColor:        Color(0xFF806858),
          textAccentColor:  Color(0xFFB8A090),
          cardBorderColor:  Color(0x44A08878),
          cardFillColor:    Color(0x14A08878),
        );

      default: // notVisible
        return const EclipseTheme(
          backgroundColors: [Color(0xFF080604), Color(0xFF120E0A), Color(0xFF1A1510)],
          accentColor:      Color(0xFF907868),
          glowColor:        Color(0xFF706050),
          textAccentColor:  Color(0xFFAA9488),
          cardBorderColor:  Color(0x44907868),
          cardFillColor:    Color(0x14907868),
        );
    }
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  static double parseMagnitude(dynamic value) {
    if (value is double) return value;
    if (value is int)    return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
