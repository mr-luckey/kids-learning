/// Project-specific analytics switches. Keep event names here, not in widgets.
///
/// Set [enabled] to `true` only after Firebase is configured
/// (`google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`).
class AnalyticsConfig {
  const AnalyticsConfig({
    this.enabled = false,
  });

  final bool enabled;

  static const eventLevelStarted = 'level_started';
  static const eventLevelCompleted = 'level_completed';
  static const eventLevelFailed = 'level_failed';
  static const eventLevelAbandoned = 'level_abandoned';
  static const eventHintUsed = 'hint_used';
  static const eventRewardClaimed = 'reward_claimed';
  static const eventDailyRewardClaimed = 'daily_reward_claimed';
  static const eventNotificationOpened = 'notification_opened';
  static const eventNotificationScheduled = 'notification_scheduled';
  static const eventRewardedAdCompleted = 'rewarded_ad_completed';
  static const eventScreenView = 'screen_view_custom';
}
