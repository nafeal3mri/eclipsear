import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Schedules local notifications for upcoming solar and lunar eclipses.
///
/// Two notifications per visible eclipse:
///   1. Day-before reminder  – fires at 09:00 the morning before the eclipse.
///   2. Eclipse-start alert  – fires at the moment the partial phase begins (C1 contact).
class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'eclipse_alerts';
  static const _channelName = 'Eclipse Alerts';
  static const _channelDesc = 'Reminders for upcoming solar and lunar eclipses';

  static const _solarDayBefore = 100;
  static const _solarStart = 101;
  static const _lunarDayBefore = 200;
  static const _lunarStart = 201;

  // ── Initialisation ────────────────────────────────────────────────────────

  static Future<void> init() async {
    try {
      tz.initializeTimeZones();
      final tzName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzName));

      const android = AndroidInitializationSettings('@mipmap/launcher_icon');
      const darwin = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      await _plugin.initialize(
        settings: const InitializationSettings(android: android, iOS: darwin),
      );

      // Request Android 13+ runtime permissions
      final androidPlugin =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();
    } catch (e) {
      debugPrint('[NotificationService] init error: $e');
    }
  }

  // ── Public scheduling API ─────────────────────────────────────────────────

  /// Cancels old eclipse notifications and schedules fresh ones.
  /// Call this whenever eclipse data is refreshed (location change, app open).
  static Future<void> scheduleEclipseNotifications({
    dynamic nextSolar,
    dynamic nextLunar,
  }) async {
    await _plugin.cancel(id: _solarDayBefore);
    await _plugin.cancel(id: _solarStart);
    await _plugin.cancel(id: _lunarDayBefore);
    await _plugin.cancel(id: _lunarStart);

    if (nextSolar != null && nextSolar['Type'] != 'notVisible') {
      await _scheduleForEclipse(
        eclipse: nextSolar,
        label: 'Solar',
        emoji: '☀️',
        idDayBefore: _solarDayBefore,
        idStart: _solarStart,
      );
    }

    if (nextLunar != null && nextLunar['Type'] != 'notVisible') {
      await _scheduleForEclipse(
        eclipse: nextLunar,
        label: 'Lunar',
        emoji: '🌙',
        idDayBefore: _lunarDayBefore,
        idStart: _lunarStart,
      );
    }
  }

  // ── Internal helpers ──────────────────────────────────────────────────────

  static Future<void> _scheduleForEclipse({
    required dynamic eclipse,
    required String label,
    required String emoji,
    required int idDayBefore,
    required int idStart,
  }) async {
    try {
      final date = eclipse['date'] as String;           // "YYYY-MM-DD"
      final startTime = eclipse['Time'] as String;      // "HH:MM:SS" – C1 contact
      final maxTime = eclipse['maxEclipse'] as String;  // "HH:MM:SS"

      final eclipseStart = DateTime.parse('$date $startTime');
      final eclipseMax = DateTime.parse('$date $maxTime');
      final now = DateTime.now();

      // 1 ── Day-before reminder at 09:00 AM
      final reminder = DateTime(
        eclipseStart.year,
        eclipseStart.month,
        eclipseStart.day - 1,
        9, 0, 0,
      );
      if (reminder.isAfter(now)) {
        await _schedule(
          id: idDayBefore,
          title: '$emoji $label Eclipse Tomorrow!',
          body:
              'Partial phase begins at ${_hhmm(eclipseStart)}. '
              'Maximum at ${_hhmm(eclipseMax)}.',
          when: reminder,
        );
        debugPrint('[NotificationService] "$label day-before" → $reminder');
      }

      // 2 ── Eclipse-start alert at the C1 contact moment
      if (eclipseStart.isAfter(now)) {
        await _schedule(
          id: idStart,
          title: '$emoji $label Eclipse Starting Now!',
          body:
              'The partial phase has begun. '
              'Maximum eclipse at ${_hhmm(eclipseMax)}.',
          when: eclipseStart,
        );
        debugPrint('[NotificationService] "$label start" → $eclipseStart');
      }
    } catch (e) {
      debugPrint('[NotificationService] schedule error for $label: $e');
    }
  }

  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(when, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static String _hhmm(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
