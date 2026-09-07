/// Flip to `false` for Play Store / App Store release builds.
/// When `true`, one JSON notification is scheduled every [NotificationConfig.testIntervalSeconds].
const bool kNotificationTestMode = false;

class NotificationMessage {
  const NotificationMessage({
    required this.id,
    required this.title,
    required this.body,
  });

  final String id;
  final String title;
  final String body;

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }
}

enum NotificationRotationMode { alternate, sequential }

class NotificationConfig {
  const NotificationConfig({
    this.enabled = true,
    this.assetPath = 'assets/notifications/notifications.json',
    this.scheduleTimes = const ['17:00', '21:00'],
    this.rotationMode = NotificationRotationMode.alternate,
    this.daysToSchedule = 14,
    this.testMode = kNotificationTestMode,
    this.testIntervalSeconds = 10,
    this.testNotificationCount = 4,
    this.androidChannelId = 'daily_local',
    this.androidChannelName = 'Daily reminders',
  });

  final bool enabled;
  final String assetPath;

  /// Local clock times `HH:mm`. Alternating mode walks this list by day index.
  final List<String> scheduleTimes;
  final NotificationRotationMode rotationMode;
  final int daysToSchedule;

  /// Dev-only: schedule one notification every [testIntervalSeconds].
  final bool testMode;
  final int testIntervalSeconds;

  /// How many test notifications to queue (cycles JSON messages).
  final int testNotificationCount;

  final String androidChannelId;
  final String androidChannelName;
}
