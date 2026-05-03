import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders the correct SVG icon for a given eclipse type + category,
/// wrapped with a dynamic glow bloom that matches the eclipse's color.
class EclipseIconWidget extends StatelessWidget {
  final String eclipseType;     // 'totalEclipse' | 'annularEclipse' | 'partialEclipse' | 'notVisible' | ...
  final String eclipseCategory; // 'solar' | 'lunar'
  final double size;
  final Color glowColor;

  const EclipseIconWidget({
    super.key,
    required this.eclipseType,
    required this.eclipseCategory,
    this.size = 160.0,
    required this.glowColor,
  });

  String get _svgAsset {
    if (eclipseCategory == 'solar') {
      switch (eclipseType) {
        case 'totalEclipse':   return 'assets/svg/solar_total.svg';
        case 'annularEclipse': return 'assets/svg/solar_annular.svg';
        case 'partialEclipse': return 'assets/svg/solar_partial.svg';
        default:               return 'assets/svg/solar_invisible.svg';
      }
    } else {
      switch (eclipseType) {
        case 'totalEclipse':      return 'assets/svg/lunar_total.svg';
        case 'partialEclipse':    return 'assets/svg/lunar_partial.svg';
        case 'penumbralEclipse':  return 'assets/svg/lunar_penumbral.svg';
        default:                  return 'assets/svg/lunar_invisible.svg';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          // Tight inner glow
          BoxShadow(
            color: glowColor.withOpacity(0.40),
            blurRadius: size * 0.30,
            spreadRadius: size * 0.02,
          ),
          // Wide outer bloom
          BoxShadow(
            color: glowColor.withOpacity(0.18),
            blurRadius: size * 0.70,
            spreadRadius: size * 0.06,
          ),
        ],
      ),
      child: SvgPicture.asset(
        _svgAsset,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
