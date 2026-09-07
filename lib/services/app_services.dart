import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:kids/core/config/analytics_config.dart';
import 'package:kids/core/config/app_ads_config.dart';
import 'package:kids/core/config/notification_config.dart';
import 'package:kids/services/ads_service.dart';
import 'package:kids/services/analytics_service.dart';
import 'package:kids/services/local_notification_service.dart';

/// App-wide singletons for analytics, ads, and local notifications.
class AppServices {
  AppServices._();

  static AnalyticsService? _analytics;
  static AdsService? _ads;
  static LocalNotificationService? _notifications;
  static bool _started = false;

  static AnalyticsService get analytics =>
      _analytics ??= AnalyticsService(config: const AnalyticsConfig());

  static AdsService get ads =>
      _ads ??= AdsService(config: appAdsConfig);

  static LocalNotificationService get notifications =>
      _notifications ??= LocalNotificationService(
        config: const NotificationConfig(),
        onTap: (String? payload) {
          unawaited(
            analytics.logNotificationOpened(
              notificationId: payload,
              source: 'local',
            ),
          );
        },
      );

  /// Non-blocking bootstrap. Safe to call once from [main].
  ///
  /// Does **not** initialize Firebase until config files exist and
  /// [AnalyticsConfig.enabled] is flipped to true.
  static Future<void> start() async {
    if (_started) return;
    _started = true;

    try {
      await analytics.init();
    } catch (error, stack) {
      debugPrint('Analytics bootstrap failed: $error\n$stack');
    }

    // Notifications need the permission dialog before first frame when possible.
    await _startNotifications();
    // Ads SDK must be ready before first banner paint (otherwise load is skipped).
    await _startAds();
  }

  static Future<void> _startAds() async {
    try {
      await ads.start();
      if (ads.isOnline) {
        unawaited(ads.preloadInterstitial(placement: 'section_open'));
        unawaited(ads.preloadRewarded(placement: 'bonus_cheer'));
      }
    } catch (error, stack) {
      debugPrint('Ads bootstrap failed: $error\n$stack');
    }
  }

  static Future<void> _startNotifications() async {
    try {
      final int count = await notifications.scheduleNotifications();
      await analytics.logNotificationScheduled(
        count: count,
        source: 'launch',
      );
    } catch (error, stack) {
      debugPrint('Notifications bootstrap failed: $error\n$stack');
    }
  }
}
