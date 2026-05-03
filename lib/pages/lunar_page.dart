import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:eclipsear/const/eclipse_theme.dart';
import 'package:eclipsear/eclipseDetails.dart';
import 'package:eclipsear/l10n/app_localizations.dart';
import 'package:eclipsear/models/dateFormatter.dart';
import 'package:eclipsear/widgets/eclipse_icon_widget.dart';

class LunarPage extends StatefulWidget {
  final List<dynamic> allEclipses;
  final dynamic nextEclipse;
  final double userLat;
  final double userLon;
  final String userCity;

  const LunarPage({
    super.key,
    required this.allEclipses,
    required this.nextEclipse,
    required this.userLat,
    required this.userLon,
    required this.userCity,
  });

  @override
  State<LunarPage> createState() => _LunarPageState();
}

class _LunarPageState extends State<LunarPage> {
  late int _selectedYear;
  late List<int> _availableYears;

  @override
  void initState() {
    super.initState();
    _buildYears();
  }

  @override
  void didUpdateWidget(LunarPage old) {
    super.didUpdateWidget(old);
    if (old.allEclipses != widget.allEclipses) _buildYears();
  }

  void _buildYears() {
    final now = DateTime.now().year;
    final years = <int>{};
    for (final e in widget.allEclipses) {
      final y = DateTime.parse(e['DateTime']).year;
      if (y >= now && y <= now + 10) years.add(y);
    }
    _availableYears = years.toList()..sort();
    if (_availableYears.isEmpty) {
      _availableYears = List.generate(5, (i) => now + i);
    }
    _selectedYear = _availableYears.contains(now) ? now : _availableYears.first;
  }

  List<dynamic> get _filteredEclipses {
    return widget.allEclipses.where((e) {
      final y = DateTime.parse(e['DateTime']).year;
      return y == _selectedYear;
    }).toList();
  }

  EclipseTheme get _theme {
    if (widget.nextEclipse == null) {
      return EclipseTheme.forLunar('notVisible', 0.0);
    }
    return EclipseTheme.forLunar(
      widget.nextEclipse['Type'] as String? ?? 'notVisible',
      EclipseTheme.parseMagnitude(widget.nextEclipse['eclipseMg']),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme;
    final loc = AppLocalizations.of(context)!;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _LunarHeroCard(
            nextEclipse: widget.nextEclipse,
            theme: theme,
            eclipseCategory: 'lunar',
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: _LunarYearSelector(
              years: _availableYears,
              selectedYear: _selectedYear,
              accentColor: theme.accentColor,
              onYearSelected: (y) => setState(() => _selectedYear = y),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Text(
              loc.upcomingEclipses,
              style: TextStyle(
                color: Colors.white.withOpacity(0.70),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        _filteredEclipses.isEmpty
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      loc.noEclipsesInRange,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.25),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final e = _filteredEclipses[i];
                    final isNext = widget.nextEclipse != null &&
                        e['date'] == widget.nextEclipse['date'];
                    return _LunarEclipseListTile(
                      eclipseData: e,
                      eclipseCategory: 'lunar',
                      isNext: isNext,
                      theme: theme,
                    );
                  },
                  childCount: _filteredEclipses.length,
                ),
              ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  HERO COUNTDOWN CARD
// ─────────────────────────────────────────────────────────────────────────────

class _LunarHeroCard extends StatefulWidget {
  final dynamic nextEclipse;
  final EclipseTheme theme;
  final String eclipseCategory;

  const _LunarHeroCard({
    required this.nextEclipse,
    required this.theme,
    required this.eclipseCategory,
  });

  @override
  State<_LunarHeroCard> createState() => _LunarHeroCardState();
}

class _LunarHeroCardState extends State<_LunarHeroCard> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    if (widget.nextEclipse == null) return;
    final maxDt =
        '${widget.nextEclipse['date']} ${widget.nextEclipse['maxEclipse']}';
    setState(() {
      _remaining = DateTime.parse(maxDt).difference(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _fmtTime(dynamic raw) {
    final s = raw?.toString() ?? '--:--';
    if (s == '--:--:--') return '--:--';
    return s.length >= 5 ? s.substring(0, 5) : s;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = widget.theme;

    if (widget.nextEclipse == null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            loc.noUpcomingLunarEclipse,
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    final type = widget.nextEclipse['Type'] as String? ?? 'notVisible';
    final typeName = loc.eclipseType('${widget.eclipseCategory}$type');
    final dateStr = DateFormatter().getdatetimgformatted(
      false, widget.nextEclipse['date'],
      dateFormat: 'MMMM d, yyyy',
    );

    final days = _remaining.isNegative ? 0 : _remaining.inDays;
    final hours = _remaining.isNegative ? 0 : _remaining.inHours.remainder(24);
    final mins = _remaining.isNegative ? 0 : _remaining.inMinutes.remainder(60);
    final secs = _remaining.isNegative ? 0 : _remaining.inSeconds.remainder(60);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                // ── Top section: countdown + eclipse icon ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 10, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.nextEclipse,
                              style: TextStyle(
                                color: theme.textAccentColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              typeName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '$days',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 62,
                                    fontWeight: FontWeight.w700,
                                    height: 0.9,
                                    shadows: [
                                      Shadow(
                                        color: theme.glowColor.withOpacity(0.25),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  loc.days.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.50),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _countdownUnit(hours.toString().padLeft(2, '0'), loc.hrs),
                                const SizedBox(width: 16),
                                _countdownUnit(mins.toString().padLeft(2, '0'), loc.mins),
                                const SizedBox(width: 16),
                                _countdownUnit(secs.toString().padLeft(2, '0'), loc.secs),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white.withOpacity(0.40),
                                  size: 13,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  dateStr,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.45),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Right: Eclipse SVG icon + See details button
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: EclipseIconWidget(
                              eclipseType: type,
                              eclipseCategory: widget.eclipseCategory,
                              size: 120,
                              glowColor: theme.glowColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EclipseDetailsPage(
                                  title: DateFormatter().getdatetimgformatted(
                                      false, widget.nextEclipse['date']),
                                  eclipseData: widget.nextEclipse,
                                  eclipseType: widget.eclipseCategory,
                                ),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.18),
                                  width: 0.8,
                                ),
                                color: Colors.white.withOpacity(0.06),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    loc.seeDetails,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.10),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white.withOpacity(0.70),
                                      size: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Divider ──
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 0.5,
                  color: Colors.white.withOpacity(0.06),
                ),

                // ── START / MAX / END time row (inside card) ──
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  decoration: BoxDecoration(
                    color: theme.accentColor.withOpacity(0.04),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      _timeColumn(
                        icon: Icons.brightness_4_outlined,
                        label: loc.start.toUpperCase(),
                        time: _fmtTime(widget.nextEclipse['Time']),
                        isMax: false,
                      ),
                      _timeDivider(),
                      _timeColumn(
                        icon: Icons.brightness_7_outlined,
                        label: loc.max.toUpperCase(),
                        time: _fmtTime(widget.nextEclipse['maxEclipse']),
                        isMax: true,
                      ),
                      _timeDivider(),
                      _timeColumn(
                        icon: Icons.brightness_4_outlined,
                        label: loc.end.toUpperCase(),
                        time: _fmtTime(widget.nextEclipse['peEnd']),
                        isMax: false,
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

  Widget _countdownUnit(String value, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _timeColumn({
    required IconData icon,
    required String label,
    required String time,
    required bool isMax,
  }) {
    final theme = widget.theme;
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: isMax
                ? theme.accentColor.withOpacity(0.60)
                : Colors.white.withOpacity(0.25),
            size: 16,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            time,
            style: TextStyle(
              color: isMax ? theme.textAccentColor : Colors.white.withOpacity(0.70),
              fontSize: 17,
              fontWeight: isMax ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            'PDT',
            style: TextStyle(
              color: Colors.white.withOpacity(0.25),
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeDivider() {
    return Container(
      width: 0.5,
      height: 44,
      color: Colors.white.withOpacity(0.08),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  YEAR SELECTOR
// ─────────────────────────────────────────────────────────────────────────────

class _LunarYearSelector extends StatelessWidget {
  final List<int> years;
  final int selectedYear;
  final Color accentColor;
  final ValueChanged<int> onYearSelected;

  const _LunarYearSelector({
    required this.years,
    required this.selectedYear,
    required this.accentColor,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: years.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final y = years[i];
                final isSelected = y == selectedYear;
                return GestureDetector(
                  onTap: () => onYearSelected(y),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accentColor.withOpacity(0.18)
                          : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? accentColor.withOpacity(0.45)
                            : Colors.white.withOpacity(0.08),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      y.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.40),
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.04),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 0.8,
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: Colors.white.withOpacity(0.40),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ECLIPSE LIST TILE
// ─────────────────────────────────────────────────────────────────────────────

class _LunarEclipseListTile extends StatelessWidget {
  final dynamic eclipseData;
  final String eclipseCategory;
  final bool isNext;
  final EclipseTheme theme;

  const _LunarEclipseListTile({
    required this.eclipseData,
    required this.eclipseCategory,
    required this.isNext,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final type = eclipseData['Type'] as String? ?? 'notVisible';
    final typeName = loc.eclipseType('$eclipseCategory$type');
    final dateStr = DateFormatter().getdatetimgformatted(
      false, eclipseData['date'],
      dateFormat: 'MMM d, yyyy',
    );

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EclipseDetailsPage(
            title:
                DateFormatter().getdatetimgformatted(false, eclipseData['date']),
            eclipseData: eclipseData,
            eclipseType: eclipseCategory,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isNext
              ? theme.cardFillColor
              : Colors.white.withOpacity(0.04),
          border: Border.all(
            color: isNext
                ? theme.cardBorderColor
                : Colors.white.withOpacity(0.06),
            width: isNext ? 1.1 : 0.6,
          ),
        ),
        child: Row(
          children: [
            EclipseIconWidget(
              eclipseType: type,
              eclipseCategory: eclipseCategory,
              size: 40,
              glowColor: isNext ? theme.glowColor : Colors.transparent,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isNext
                          ? theme.textAccentColor
                          : Colors.white.withOpacity(0.80),
                      fontSize: 14,
                      fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white.withOpacity(0.30),
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateStr,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.38),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.20),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
