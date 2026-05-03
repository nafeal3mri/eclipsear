import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:eclipsear/const/eclipse_theme.dart';
import 'package:eclipsear/models/dateFormatter.dart';
import 'package:eclipsear/l10n/app_localizations.dart';
import 'package:eclipsear/widgets/eclipse_icon_widget.dart';

class EclipseListCard extends StatelessWidget {
  final dynamic eclipseData;
  final String eclipseCategory; // 'solar' | 'lunar'
  final bool isNext;
  final EclipseTheme theme;
  final VoidCallback onTap;

  const EclipseListCard({
    super.key,
    required this.eclipseData,
    required this.eclipseCategory,
    required this.isNext,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc  = AppLocalizations.of(context)!;
    final type = eclipseData['Type'] as String? ?? 'notVisible';
    final mag  = EclipseTheme.parseMagnitude(eclipseData['eclipseMg']);

    final dateStr = DateFormatter().getdatetimgformatted(
      false, eclipseData['date'], dateFormat: 'd MMM yyyy',
    );
    final typeName = loc.eclipseType(eclipseCategory + type);

    final startTime  = _fmtTime(eclipseData['Time']);
    final maxTime    = _fmtTime(eclipseData['maxEclipse']);
    final endTime    = _fmtTime(eclipseData['peEnd']);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isNext
                    ? theme.cardFillColor
                    : Colors.white.withOpacity(0.045),
                border: Border.all(
                  color: isNext
                      ? theme.cardBorderColor
                      : Colors.white.withOpacity(0.08),
                  width: isNext ? 1.4 : 0.7,
                ),
              ),
              child: Row(
                children: [
                  // ── Icon
                  EclipseIconWidget(
                    eclipseType: type,
                    eclipseCategory: eclipseCategory,
                    size: 52,
                    glowColor: isNext ? theme.glowColor : Colors.white,
                  ),
                  const SizedBox(width: 14),
                  // ── Text block
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                typeName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isNext
                                      ? theme.textAccentColor
                                      : Colors.white.withOpacity(0.85),
                                  fontSize: 14,
                                  fontWeight: isNext
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (isNext) _nextBadge(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateStr,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 12,
                          ),
                        ),
                        if (startTime != null || maxTime != null || endTime != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              if (startTime != null) _timeCell('Start', startTime),
                              if (startTime != null && maxTime != null) _dot(),
                              if (maxTime != null) _timeCell('Max', maxTime),
                              if (maxTime != null && endTime != null) _dot(),
                              if (endTime != null) _timeCell('End', endTime),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // ── Chevron
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withOpacity(0.25),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nextBadge() {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.accentColor.withOpacity(0.22),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.accentColor.withOpacity(0.55),
          width: 0.8,
        ),
      ),
      child: Text(
        'NEXT',
        style: TextStyle(
          color: theme.textAccentColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _timeCell(String label, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.38),
            fontSize: 9,
            letterSpacing: 0.3,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: Colors.white.withOpacity(0.72),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _dot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  String? _fmtTime(dynamic raw) {
    final s = raw?.toString() ?? '';
    if (s.isEmpty || s == '--:--:--' || s == '--:--') return null;
    return s.length >= 5 ? s.substring(0, 5) : s;
  }
}
