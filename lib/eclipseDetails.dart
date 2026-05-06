import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:eclipsear/const/eclipse_theme.dart';
import 'package:eclipsear/eclipsePath/map_path_latlng.dart';
import 'package:eclipsear/l10n/app_localizations.dart';
import 'package:eclipsear/models/dateFormatter.dart';

import 'package:eclipsear/models/videoPlayer.dart';
import 'package:eclipsear/services/notification_service.dart';

import 'package:video_player/video_player.dart';

class EclipseDetailsPage extends StatefulWidget {
  const EclipseDetailsPage({
    super.key,
    required this.title,
    required this.eclipseData,
    required this.eclipseType,
  });

  final String title;
  final dynamic eclipseData;
  final String eclipseType;

  @override
  State<EclipseDetailsPage> createState() => _EclipseDetailsPageState();
}

class _EclipseDetailsPageState extends State<EclipseDetailsPage> {
  EclipsePathData _pathData = EclipsePathData.empty;
  bool _pathLoading = true;
  final _mapController = MapController();

  VideoPlayerController? _vidController;
  bool _videoInitialized = false;
  bool _videoLoading = false;
  bool _videoError = false;

  String _userCity = '';

  @override
  void initState() {
    super.initState();
    _loadPathData();
    _loadUserLocation();
    if (widget.eclipseType == 'solar') _initVideo();
  }

  @override
  void dispose() {
    _vidController?.dispose();
    super.dispose();
  }

  Future<void> _loadUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _userCity = prefs.getString('cityname') ?? '';
    });
  }

  Future<void> _loadPathData() async {
    final data = await fetchEclipsePath(
      widget.eclipseData['date'] as String,
      eclipseType: widget.eclipseType,
    );
    if (!mounted) return;
    setState(() {
      _pathData = data;
      _pathLoading = false;
    });
  }

  Future<void> _initVideo() async {
    if (!mounted) return;
    setState(() {
      _videoLoading = true;
      _videoError = false;
    });
    try {
      final fmt = DateFormatter().getdatetimgformatted(
              false, widget.eclipseData['date'], dateFormat: 'yyyyMMdd') +
          '_B';
      final url = 'https://in-the-sky.org/news/eclipses/solar_$fmt.mp4';
      _vidController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _vidController!.initialize().timeout(const Duration(seconds: 30));
      _vidController!.setLooping(true);
      if (!mounted) return;
      setState(() {
        _videoInitialized = true;
        _videoLoading = false;
      });
      await _vidController!.play();
    } catch (e) {
      debugPrint('Video init error: $e');
      _vidController?.dispose();
      _vidController = null;
      if (!mounted) return;
      setState(() {
        _videoLoading = false;
        _videoError = true;
      });
    }
  }

  EclipseTheme get _theme {
    final type = widget.eclipseData['Type'] as String? ?? 'notVisible';
    final mag = EclipseTheme.parseMagnitude(widget.eclipseData['eclipseMg']);
    return widget.eclipseType == 'solar'
        ? EclipseTheme.forSolar(type, mag)
        : EclipseTheme.forLunar(type, mag);
  }

  void _shareEclipse() {
    final loc = AppLocalizations.of(context)!;
    final type = widget.eclipseData['Type'] as String? ?? 'notVisible';
    final shortType = _shortTypeName(loc, type);
    final isSolar = widget.eclipseType == 'solar';
    final categoryName = isSolar ? loc.solarEclipse : loc.lunarEclipse;
    final dateStr = DateFormatter().getdatetimgformatted(
      false, widget.eclipseData['date'],
      dateFormat: 'MMMM d, yyyy',
    );
    final startTime = _fmt(widget.eclipseData['Time']);
    final maxTime = _fmt(widget.eclipseData['maxEclipse']);
    final endTime = _fmt(widget.eclipseData['peEnd']);

    final buffer = StringBuffer();
    buffer.writeln('${isSolar ? "☀️" : "🌙"} $shortType $categoryName');
    buffer.writeln('📅 $dateStr');
    if (type != 'notVisible') {
      buffer.writeln('⏰ $startTime → $maxTime → $endTime');
    }
    if (_userCity.isNotEmpty) {
      buffer.writeln('📍 $_userCity');
    }
    if (isSolar && type != 'notVisible') {
      final cov = widget.eclipseData['coverage'];
      if (cov != null) {
        final c = (cov is num) ? cov.toDouble() : double.tryParse(cov.toString()) ?? 0.0;
        final pct = c >= 1.0 ? '100%' : '${(c * 100).toStringAsFixed(0)}%';
        buffer.writeln('👁️ $pct coverage');
      }
    }
    buffer.writeln();
    buffer.write(loc.sharedViaEclipsear);

    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : const Rect.fromLTWH(0, 0, 1, 1);
    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        sharePositionOrigin: origin,
      ),
    );
  }

  Future<void> _setReminder() async {
    final loc = AppLocalizations.of(context)!;
    final theme = _theme;

    final dateStr = widget.eclipseData['date'] as String? ?? '';
    final timeStr = widget.eclipseData['Time'] as String? ?? '';
    if (dateStr.isEmpty || timeStr.isEmpty) return;

    try {
      final eclipseStart = DateTime.parse('$dateStr $timeStr');
      if (eclipseStart.isBefore(DateTime.now())) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.eclipseAlreadyPassed),
            backgroundColor: Colors.white.withOpacity(0.15),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
    } catch (_) {}

    await NotificationService.scheduleEclipseNotifications(
      nextSolar: widget.eclipseType == 'solar' ? widget.eclipseData : null,
      nextLunar: widget.eclipseType == 'lunar' ? widget.eclipseData : null,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.reminderSet),
        backgroundColor: theme.accentColor.withOpacity(0.85),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _shortTypeName(AppLocalizations loc, String type) {
    switch (type) {
      case 'totalEclipse':
        return loc.typeTotal;
      case 'annularEclipse':
        return loc.typeAnnular;
      case 'partialEclipse':
        return loc.typePartial;
      case 'penumbralEclipse':
        return loc.typePenumbral;
      default:
        return loc.typeNotVisible;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme;

    final isSolar = widget.eclipseType == 'solar';
    final topPadding = MediaQuery.of(context).padding.top;
    const navBarHeight = 52.0;
    const mapHeight = 300.0;

    return Scaffold(
      backgroundColor: theme.backgroundColors.last,
      body: Column(
        children: [
          // Top region: map for solar, gradient header for lunar
          if (isSolar)
            SizedBox(
              height: topPadding + navBarHeight + mapHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _pathLoading
                        ? Container(
                            color: theme.backgroundColors.first,
                            child: _loadingOverlay(theme),
                          )
                        : _buildMap(theme),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 60,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              theme.backgroundColors.last,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: topPadding,
                    left: 0,
                    right: 0,
                    child: _DetailsNavBar(theme: theme, onShare: _shareEclipse),
                  ),
                ],
              ),
            )
          else
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: theme.backgroundColors,
                  stops: const [0.0, 0.38, 1.0],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: _DetailsNavBar(theme: theme, onShare: _shareEclipse),
              ),
            ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEclipseInfoCard(theme),
                  const SizedBox(height: 4),
                  _buildInfoCardsRow(theme),
                  if (!isSolar) _buildLunarImage(),
                  if (isSolar) _buildVideoSection(theme),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          _buildBottomButtons(theme),
        ],
      ),
    );
  }

  // ── Eclipse Info Card (unified: badge + title + metadata + timeline) ─────

  Widget _buildEclipseInfoCard(EclipseTheme theme) {
    final loc = AppLocalizations.of(context)!;
    final type = widget.eclipseData['Type'] as String? ?? 'notVisible';
    final shortType = _shortTypeName(loc, type);
    final categoryName = widget.eclipseType == 'solar' ? loc.solarEclipse : loc.lunarEclipse;
    final dateStr = DateFormatter().getdatetimgformatted(
      false, widget.eclipseData['date'],
      dateFormat: 'MMM d, yyyy',
    );

    String coverageStr = '';
    if (widget.eclipseType == 'solar' && type != 'notVisible') {
      final cov = widget.eclipseData['coverage'];
      if (cov != null) {
        final c = (cov is num) ? cov.toDouble() : double.tryParse(cov.toString()) ?? 0.0;
        coverageStr = c >= 1.0 ? '100%' : '${(c * 100).toStringAsFixed(0)}%';
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                // ── Top section: badge + title + metadata ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type badge
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.eclipseType == 'solar'
                                ? Icons.brightness_7_outlined
                                : Icons.brightness_4_outlined,
                            color: theme.textAccentColor,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${shortType.toUpperCase()} ${categoryName.toUpperCase()}',
                            style: TextStyle(
                              color: theme.textAccentColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Title
                      AutoSizeText(
                        '$shortType $categoryName',
                        maxLines: 1,
                        maxFontSize: 26,
                        minFontSize: 16,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Metadata row
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              color: Colors.white.withOpacity(0.40), size: 13),
                          const SizedBox(width: 5),
                          Text(dateStr,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.55),
                                  fontSize: 13)),
                          if (_userCity.isNotEmpty) ...[
                            const SizedBox(width: 14),
                            Icon(Icons.location_on_outlined,
                                color: Colors.white.withOpacity(0.40),
                                size: 14),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(_userCity,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.55),
                                      fontSize: 13)),
                            ),
                          ],
                          if (coverageStr.isNotEmpty) ...[
                            const SizedBox(width: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.accentColor.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.accentColor.withOpacity(0.30),
                                  width: 0.6,
                                ),
                              ),
                              child: Text(
                                '$coverageStr ${loc.visibility}',
                                style: TextStyle(
                                  color: theme.textAccentColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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

                // ── Bottom section: timeline ──
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  decoration: BoxDecoration(
                    color: theme.accentColor.withOpacity(0.04),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Progress line with dots
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          height: 20,
                          child: CustomPaint(
                            painter: _TimelinePainter(
                              dotColor: Colors.white.withOpacity(0.40),
                              lineColor: Colors.white.withOpacity(0.12),
                              accentColor: theme.accentColor,
                            ),
                            size: const Size(double.infinity, 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Labels + times + timezone
                      Row(
                        children: [
                          _timelineColumn(
                            label: loc.start.toUpperCase(),
                            time: _fmt(widget.eclipseData['Time']),
                            isMax: false,
                            theme: theme,
                          ),
                          _timelineColumn(
                            label: loc.max.toUpperCase(),
                            time: _fmt(widget.eclipseData['maxEclipse']),
                            isMax: true,
                            theme: theme,
                          ),
                          _timelineColumn(
                            label: loc.end.toUpperCase(),
                            time: _fmt(widget.eclipseData['peEnd']),
                            isMax: false,
                            theme: theme,
                          ),
                        ],
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

  Widget _timelineColumn({
    required String label,
    required String time,
    required bool isMax,
    required EclipseTheme theme,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(isMax ? 0.50 : 0.30),
              fontSize: 10,
              fontWeight: isMax ? FontWeight.w700 : FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              color: isMax ? theme.textAccentColor : Colors.white.withOpacity(0.65),
              fontSize: isMax ? 22 : 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'PDT',
            style: TextStyle(
              color: Colors.white.withOpacity(isMax ? 0.30 : 0.20),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── About This Eclipse ────────────────────────────────────────────────────

  // ── Info Cards Row ────────────────────────────────────────────────────────

  Widget _buildInfoCardsRow(EclipseTheme theme) {
    final loc = AppLocalizations.of(context)!;
    final type = widget.eclipseData['Type'] as String? ?? 'notVisible';
    final isSolar = widget.eclipseType == 'solar';

    String coverageStr = '—';
    if (isSolar && type != 'notVisible') {
      final cov = widget.eclipseData['coverage'];
      if (cov != null) {
        final c = (cov is num) ? cov.toDouble() : double.tryParse(cov.toString()) ?? 0.0;
        coverageStr = c >= 1.0 ? '100%' : '${(c * 100).toStringAsFixed(0)}%';
      }
    }

    final mag = EclipseTheme.parseMagnitude(widget.eclipseData['eclipseMg']);

    // Visibility label
    String visibilityValue = coverageStr;
    String visibilityLabel = type == 'notVisible' ? 'Not visible' : 'Excellent';
    if (mag > 0 && mag < 1.0) {
      visibilityLabel = mag > 0.7 ? 'Good' : 'Fair';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          _infoCard(
            icon: Icons.visibility_outlined,
            title: loc.visibility,
            primary: visibilityValue,
            secondary: visibilityLabel,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String primary,
    required String secondary,
    required EclipseTheme theme,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.07),
            width: 0.6,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.accentColor, size: 20),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.40),
                fontSize: 10,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              primary,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.textAccentColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              secondary,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.35),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Action Buttons ─────────────────────────────────────────────────

  Widget _buildBottomButtons(EclipseTheme theme) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _setReminder,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: theme.accentColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.accentColor.withOpacity(0.40),
                    width: 0.7,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: theme.textAccentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      loc.addReminder,
                      style: TextStyle(
                        color: theme.textAccentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: _shareEclipse,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.10),
                    width: 0.6,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.share_rounded,
                      color: Colors.white.withOpacity(0.65),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      loc.share,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(EclipseTheme theme) {
    final hasPath = _pathData.hasData;
    final center = hasPath && _pathData.centerLine.isNotEmpty
        ? _pathData.centerLine[_pathData.centerLine.length ~/ 2]
        : const LatLng(0, 0);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: hasPath ? 2.5 : 1.5,
        minZoom: 1.0,
        maxZoom: 14.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
          userAgentPackageName: 'me.nafe.eclipsear',
          maxZoom: 18,
        ),
        if (_pathData.contour5.length > 2)
          PolygonLayer(polygons: [
            Polygon(points: _pathData.contour5, color: theme.accentColor.withOpacity(0.08), borderStrokeWidth: 0),
          ]),
        if (_pathData.contour4.length > 2)
          PolygonLayer(polygons: [
            Polygon(points: _pathData.contour4, color: theme.accentColor.withOpacity(0.12), borderStrokeWidth: 0),
          ]),
        if (_pathData.contour3.length > 2)
          PolygonLayer(polygons: [
            Polygon(points: _pathData.contour3, color: theme.accentColor.withOpacity(0.18), borderStrokeWidth: 0),
          ]),
        if (_pathData.contour2.length > 2)
          PolygonLayer(polygons: [
            Polygon(points: _pathData.contour2, color: theme.accentColor.withOpacity(0.26), borderStrokeWidth: 0),
          ]),
        if (_pathData.contour1.length > 2)
          PolygonLayer(polygons: [
            Polygon(points: _pathData.contour1, color: theme.accentColor.withOpacity(0.36), borderStrokeWidth: 0),
          ]),
        if (_pathData.centerLine.length > 1)
          PolylineLayer(polylines: [
            Polyline(points: _pathData.centerLine, color: theme.accentColor, strokeWidth: 2.5),
          ]),
        const RichAttributionWidget(attributions: [TextSourceAttribution('© CartoDB  © OpenStreetMap')]),
      ],
    );
  }

  Widget _loadingOverlay(EclipseTheme theme) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: theme.accentColor, strokeWidth: 2),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.loadingEclipsePath,
                style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // ── Lunar Image ───────────────────────────────────────────────────────────

  Widget _buildLunarImage() {
    final fmt = DateFormatter().getdatetimgformatted(
        false, widget.eclipseData['date'], dateFormat: 'yyyyMMdd');
    final url = 'https://in-the-sky.org/news/eclipses/lunar_$fmt.png';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(AppLocalizations.of(context)!.eclipseDiagram, Icons.image_outlined, _theme),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              url,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 160,
                  color: Colors.black38,
                  child: Center(
                    child: CircularProgressIndicator(color: _theme.accentColor, strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(AppLocalizations.of(context)!.diagramUnavailable,
                      style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 13)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Video Section ─────────────────────────────────────────────────────────

  Widget _buildVideoSection(EclipseTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(AppLocalizations.of(context)!.eclipseSimulation, Icons.play_circle_outline_rounded, theme),
          const SizedBox(height: 10),
          _buildVideoContent(theme),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context)!.simulationAttribution,
            style: TextStyle(color: Colors.white.withOpacity(0.28), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoContent(EclipseTheme theme) {
    if (_videoLoading) {
      return Container(
        height: 200,
        color: Colors.black38,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: theme.accentColor, strokeWidth: 2),
              const SizedBox(height: 12),
              Text(AppLocalizations.of(context)!.loadingSimulation,
                  style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13)),
            ],
          ),
        ),
      );
    }

    if (_videoError || (!_videoInitialized && !_videoLoading)) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.07), width: 0.7),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam_off_rounded, color: Colors.white.withOpacity(0.25), size: 32),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.simulationUnavailable,
                  style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 13)),
            ],
          ),
        ),
      );
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _vidController!,
      builder: (context, value, _) {
        final ratio = value.aspectRatio > 0 ? value.aspectRatio : 16 / 9;
        return AspectRatio(
          aspectRatio: ratio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              VideoPlayer(_vidController!),
              ControlsOverlay(controller: _vidController!, accentColor: theme.accentColor),
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: VideoProgressIndicator(
                  _vidController!,
                  allowScrubbing: true,
                  colors: VideoProgressColors(playedColor: theme.accentColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon, EclipseTheme theme) {
    return Row(
      children: [
        Icon(icon, color: theme.accentColor, size: 16),
        const SizedBox(width: 6),
        Text(title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            )),
      ],
    );
  }

  String _fmt(dynamic raw) {
    final s = raw?.toString() ?? '--:--';
    if (s == '--:--:--') return '--:--';
    return s.length >= 5 ? s.substring(0, 5) : s;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  NAV BAR
// ─────────────────────────────────────────────────────────────────────────────

class _DetailsNavBar extends StatelessWidget {
  final EclipseTheme theme;
  final VoidCallback onShare;
  const _DetailsNavBar({required this.theme, required this.onShare});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
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
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white.withOpacity(0.80), size: 18),
            ),
          ),
          Expanded(
            child: Text(
              loc.eclipseDetails,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onShare,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
              child: Icon(Icons.ios_share_rounded,
                  color: Colors.white.withOpacity(0.65), size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TIMELINE PAINTER (horizontal line with 3 dots)
// ─────────────────────────────────────────────────────────────────────────────

class _TimelinePainter extends CustomPainter {
  final Color dotColor;
  final Color lineColor;
  final Color accentColor;

  _TimelinePainter({
    required this.dotColor,
    required this.lineColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;

    // Horizontal line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);

    // Three dots at START, MAX, END
    final positions = [0.0, size.width / 2, size.width];
    final radii = [5.0, 7.0, 5.0];
    final colors = [dotColor, accentColor, dotColor];

    for (int i = 0; i < 3; i++) {
      // Outer ring
      final ringPaint = Paint()
        ..color = colors[i].withOpacity(0.50)
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(positions[i], y), radii[i], ringPaint);

      // Inner fill
      final fillPaint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(positions[i], y), radii[i] - 2.0, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
