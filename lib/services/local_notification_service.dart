import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:kids/core/config/notification_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

typedef NotificationTapCallback = void Function(String? payload);

/// Fully offline local notifications. Idempotent. Device-local timezone.
///
/// Uses **inexact** Android alarms only — no `SCHEDULE_EXACT_ALARM` / Alarms
/// permission. Daily reminders still fire with the app killed via plugin
/// receivers + AlarmManager. Short test intervals use an in-process timer
/// (no special permission) plus inexact schedules as a kill-state fallback.
class LocalNotificationService {
  LocalNotificationService({
    NotificationConfig config = const NotificationConfig(),
    FlutterLocalNotificationsPlugin? plugin,
    this.onTap,
  })  : _config = config,
        _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _fingerprintKey = 'local_notification_fingerprint_v1';

  /// Always inexact — never prompts for Alarms & reminders.
  static const AndroidScheduleMode _scheduleMode =
      AndroidScheduleMode.inexactAllowWhileIdle;

  final NotificationConfig _config;
  final FlutterLocalNotificationsPlugin _plugin;
  final NotificationTapCallback? onTap;

  bool _initialized = false;
  Timer? _testTimer;

  Future<void> init() async {
    if (!_config.enabled || _initialized) return;
    try {
      tz_data.initializeTimeZones();
      await _configureLocalTimezone();

      const AndroidInitializationSettings android =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings ios = DarwinInitializationSettings();
      await _plugin.initialize(
        settings: const InitializationSettings(android: android, iOS: ios),
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          onTap?.call(response.payload);
        },
      );
      await _ensureAndroidChannel();
      _initialized = true;
    } catch (error, stack) {
      debugPrint('LocalNotificationService.init failed: $error\n$stack');
    }
  }

  Future<bool> requestPermission() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? android = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final IOSFlutterLocalNotificationsPlugin? ios = _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      final bool androidOk =
          await android?.requestNotificationsPermission() ?? true;
      final bool iosOk = await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          true;
      // Intentionally no requestExactAlarmsPermission().
      return androidOk && iosOk;
    } catch (error, stack) {
      debugPrint('Notification permission failed: $error\n$stack');
      return false;
    }
  }

  /// Safe to call on every launch. Does not create duplicates
  /// (except [NotificationConfig.testMode], which always requeues).
  Future<int> scheduleNotifications() async {
    if (!_config.enabled) return 0;
    await init();
    if (!_initialized) return 0;

    final bool allowed = await requestPermission();
    if (!allowed) {
      debugPrint('Notifications skipped: permission denied');
      return 0;
    }

    try {
      final List<NotificationMessage> messages = await _loadMessages();
      if (messages.isEmpty) {
        debugPrint('Notifications skipped: empty JSON messages');
        return 0;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (_config.testMode) {
        await _plugin.cancelAll();
        await prefs.remove(_fingerprintKey);
        final int count = await _startTestBurst(messages);
        debugPrint(
          'Notification testMode: $count every '
          '${_config.testIntervalSeconds}s (no exact-alarm permission)',
        );
        return count;
      }

      _stopTestTimer();

      final String fingerprint = await _fingerprint(messages);
      if (prefs.getString(_fingerprintKey) == fingerprint) {
        final List<PendingNotificationRequest> pending =
            await _plugin.pendingNotificationRequests();
        if (pending.isNotEmpty) return pending.length;
      }

      await _plugin.cancelAll();
      final int count = await _scheduleUpcoming(messages);
      await prefs.setString(_fingerprintKey, fingerprint);
      debugPrint('Notifications scheduled=$count mode=$_scheduleMode');
      return count;
    } catch (error, stack) {
      debugPrint('scheduleNotifications failed: $error\n$stack');
      return 0;
    }
  }

  Future<void> cancelAll() async {
    try {
      _stopTestTimer();
      await _plugin.cancelAll();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_fingerprintKey);
    } catch (error, stack) {
      debugPrint('cancelAll notifications failed: $error\n$stack');
    }
  }

  Future<List<NotificationMessage>> _loadMessages() async {
    final String raw = await rootBundle.loadString(_config.assetPath);
    final Map<String, dynamic> decoded =
        jsonDecode(raw) as Map<String, dynamic>;
    final List<dynamic> list =
        decoded['notifications'] as List<dynamic>? ?? const <dynamic>[];
    return list
        .whereType<Map<String, dynamic>>()
        .map(NotificationMessage.fromJson)
        .where((NotificationMessage m) =>
            m.id.isNotEmpty && m.title.isNotEmpty)
        .toList();
  }

  NotificationDetails _details({bool high = false}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _config.androidChannelId,
        _config.androidChannelName,
        channelDescription: 'Kids Learning local reminders',
        importance: high ? Importance.high : Importance.defaultImportance,
        priority: high ? Priority.high : Priority.defaultPriority,
        playSound: true,
        enableVibration: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  /// Test burst without exact alarms:
  /// 1) In-process [Timer] + [show] every N seconds (reliable while process lives)
  /// 2) Inexact [zonedSchedule] so something can still arrive after kill (timing
  ///    may be delayed by Android Doze; no Alarms permission needed)
  Future<int> _startTestBurst(List<NotificationMessage> messages) async {
    final int count = _config.testNotificationCount.clamp(1, 50);
    final int interval = _config.testIntervalSeconds.clamp(1, 3600);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Kill-state fallback (inexact — may batch / delay on Android).
    for (int i = 0; i < count; i++) {
      final NotificationMessage message = messages[i % messages.length];
      final tz.TZDateTime fire =
          now.add(Duration(seconds: interval * (i + 1)));
      await _plugin.zonedSchedule(
        id: 9000 + i,
        title: '[TEST ${i + 1}/$count] ${message.title}',
        body: message.body,
        scheduledDate: fire,
        notificationDetails: _details(high: true),
        androidScheduleMode: _scheduleMode,
        payload: message.id,
      );
    }

    // Precise 10s cadence while app process is alive — no alarm permission.
    _stopTestTimer();
    int shown = 0;
    _testTimer = Timer.periodic(Duration(seconds: interval), (Timer timer) async {
      if (shown >= count) {
        timer.cancel();
        _testTimer = null;
        return;
      }
      final NotificationMessage message = messages[shown % messages.length];
      final int index = shown + 1;
      shown++;
      try {
        // Avoid double-fire: cancel the matching inexact schedule.
        await _plugin.cancel(id: 9000 + (index - 1));
        await _plugin.show(
          id: 9100 + index,
          title: '[TEST $index/$count] ${message.title}',
          body: message.body,
          notificationDetails: _details(high: true),
          payload: message.id,
        );
        debugPrint('Test notif $index shown via timer');
      } catch (error, stack) {
        debugPrint('Test show failed: $error\n$stack');
      }
    });

    return count;
  }

  void _stopTestTimer() {
    _testTimer?.cancel();
    _testTimer = null;
  }

  Future<int> _scheduleUpcoming(List<NotificationMessage> messages) async {
    int scheduled = 0;
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    for (int day = 0; day < _config.daysToSchedule; day++) {
      final ({int hour, int minute})? time = _timeForDay(day);
      if (time == null) continue;
      final tz.TZDateTime fire = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      ).add(Duration(days: day));
      if (!fire.isAfter(now)) continue;
      final NotificationMessage message = messages[day % messages.length];
      await _plugin.zonedSchedule(
        id: day + 1,
        title: message.title,
        body: message.body,
        scheduledDate: fire,
        notificationDetails: _details(),
        androidScheduleMode: _scheduleMode,
        payload: message.id,
      );
      scheduled++;
    }
    return scheduled;
  }

  ({int hour, int minute})? _timeForDay(int dayIndex) {
    final List<String> times = _config.scheduleTimes;
    if (times.isEmpty) return null;
    final String token =
        _config.rotationMode == NotificationRotationMode.alternate
            ? times[dayIndex % times.length]
            : times[0];
    final List<String> parts = token.split(':');
    if (parts.length != 2) return null;
    return (hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _configureLocalTimezone() async {
    try {
      final String name = await _localTimezoneName();
      tz.setLocalLocation(tz.getLocation(name));
      debugPrint('Notification timezone: $name');
    } catch (error) {
      debugPrint('Timezone lookup failed ($error); keeping default local');
    }
  }

  Future<void> _ensureAndroidChannel() async {
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      AndroidNotificationChannel(
        _config.androidChannelId,
        _config.androidChannelName,
        description: 'Kids Learning local reminders',
        importance: Importance.high,
      ),
    );
  }

  Future<String> _localTimezoneName() async {
    final TimezoneInfo info = await FlutterTimezone.getLocalTimezone();
    return info.identifier;
  }

  Future<String> _fingerprint(List<NotificationMessage> messages) async {
    final String payload = jsonEncode(<String, Object>{
      'tz': await _localTimezoneName(),
      'times': _config.scheduleTimes,
      'mode': _config.rotationMode.name,
      'days': _config.daysToSchedule,
      'messages': messages
          .map((NotificationMessage m) => <String, String>{
                'id': m.id,
                'title': m.title,
                'body': m.body,
              })
          .toList(),
    });
    return payload;
  }
}
