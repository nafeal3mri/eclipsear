import 'package:flutter/material.dart';
import 'package:eclipsear/services/historical_weather_service.dart';

/// Displays weather on the same calendar date 1 year before the eclipse.
/// Fetches from the Open-Meteo archive API.
class HistoricalWeatherWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String eclipseDate; // "YYYY-MM-DD"
  final Color  accentColor;
  /// When true, renders as a compact vertical column (home page side panel).
  /// When false, renders as a full-width horizontal row (details page).
  final bool   compact;

  const HistoricalWeatherWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.eclipseDate,
    required this.accentColor,
    this.compact = false,
  });

  @override
  State<HistoricalWeatherWidget> createState() =>
      _HistoricalWeatherWidgetState();
}

class _HistoricalWeatherWidgetState extends State<HistoricalWeatherWidget> {
  HistoricalWeatherData? _data;
  bool _loading = true;
  bool _error   = false;
  late String _targetDate;

  @override
  void initState() {
    super.initState();
    _targetDate = lastYearDate(widget.eclipseDate);
    _fetch();
  }

  @override
  void didUpdateWidget(HistoricalWeatherWidget old) {
    super.didUpdateWidget(old);
    if (old.eclipseDate != widget.eclipseDate ||
        old.latitude    != widget.latitude    ||
        old.longitude   != widget.longitude) {
      _targetDate = lastYearDate(widget.eclipseDate);
      setState(() { _loading = true; _error = false; _data = null; });
      _fetch();
    }
  }

  Future<void> _fetch() async {
    if (widget.latitude == 0 && widget.longitude == 0) {
      setState(() { _loading = false; _error = true; });
      return;
    }
    final result = await fetchHistoricalWeather(
      latitude:  widget.latitude,
      longitude: widget.longitude,
      date:      _targetDate,
    );
    if (!mounted) return;
    setState(() {
      _data    = result;
      _loading = false;
      _error   = result == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? _buildLoading()
        : _error
            ? _buildError()
            : widget.compact
                ? _buildDataCompact()
                : _buildDataFull();
  }

  // ── Loading ──────────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return Center(
      child: SizedBox(
        width: 20, height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: widget.accentColor,
        ),
      ),
    );
  }

  // ── Error / no location ──────────────────────────────────────────────────

  Widget _buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.06),
          ),
          child: Icon(
            Icons.location_off_rounded,
            color: Colors.white.withOpacity(0.35),
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'No location\nset',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.32),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ── Data: compact vertical (home page side panel) ────────────────────────

  Widget _buildDataCompact() {
    final d    = _data!;
    final info = d.info;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Last year',
          style: TextStyle(
            color: Colors.white.withOpacity(0.38),
            fontSize: 10,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          friendlyDate(_targetDate),
          style: TextStyle(
            color: Colors.white.withOpacity(0.52),
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 10),
        _WeatherIconBadge(info: info),
        const SizedBox(height: 8),
        Text(
          info.description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.78),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        _DataPill(
          icon:  Icons.thermostat_rounded,
          label: d.tempRange,
          color: widget.accentColor,
        ),
        const SizedBox(height: 5),
        _DataPill(
          icon:  Icons.water_drop_rounded,
          label: d.precipStr,
          color: Colors.white.withOpacity(0.40),
        ),
      ],
    );
  }

  // ── Data: full-width horizontal (details page) ────────────────────────────

  Widget _buildDataFull() {
    final d    = _data!;
    final info = d.info;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _WeatherIconBadge(info: info),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                info.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                'Last year · ${friendlyDate(_targetDate)}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.40),
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _DataPill(
              icon:  Icons.thermostat_rounded,
              label: d.tempRange,
              color: widget.accentColor,
            ),
            const SizedBox(height: 5),
            _DataPill(
              icon:  Icons.water_drop_rounded,
              label: d.precipStr,
              color: Colors.white.withOpacity(0.40),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Glowing circular icon — same visual language as the eclipse SVG icons
// ─────────────────────────────────────────────────────────────────────────────

class _WeatherIconBadge extends StatelessWidget {
  final WeatherCodeInfo info;
  const _WeatherIconBadge({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: info.iconColor.withOpacity(0.12),
        border: Border.all(
          color: info.iconColor.withOpacity(0.28),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: info.iconColor.withOpacity(0.30),
            blurRadius: 14,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        info.icon,
        color: info.iconColor,
        size: 22,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Small inline data pill
// ─────────────────────────────────────────────────────────────────────────────

class _DataPill extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    color;
  const _DataPill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 11),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
