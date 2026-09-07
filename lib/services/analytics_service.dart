import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:kids/core/config/analytics_config.dart';

/// Central analytics facade. Never throw to callers. Never send PII.
class AnalyticsService {
  AnalyticsService({
    AnalyticsConfig config = const AnalyticsConfig(),
    FirebaseAnalytics? analytics,
  })  : _config = config,
        _analytics = analytics;

  final AnalyticsConfig _config;
  FirebaseAnalytics? _analytics;

  Future<void> init() async {
    if (!_config.enabled) return;
    try {
      _analytics ??= FirebaseAnalytics.instance;
      await _analytics!.setAnalyticsCollectionEnabled(true);
    } catch (error, stack) {
      debugPrint('Analytics init failed: $error\n$stack');
    }
  }

  Future<void> logLevelStarted({
    int? levelNumber,
    String? difficulty,
    int? attemptNumber,
    String? source,
  }) {
    return logEvent(AnalyticsConfig.eventLevelStarted, {
      if (levelNumber != null) 'level_number': levelNumber,
      if (difficulty != null) 'difficulty': difficulty,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (source != null) 'source': source,
    });
  }

  Future<void> logLevelCompleted({
    int? levelNumber,
    String? difficulty,
    int? moves,
    int? timeSeconds,
    int? attemptNumber,
    String? source,
  }) {
    return logEvent(AnalyticsConfig.eventLevelCompleted, {
      if (levelNumber != null) 'level_number': levelNumber,
      if (difficulty != null) 'difficulty': difficulty,
      if (moves != null) 'moves': moves,
      if (timeSeconds != null) 'time_seconds': timeSeconds,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (source != null) 'source': source,
    });
  }

  Future<void> logLevelFailed({
    int? levelNumber,
    String? difficulty,
    int? moves,
    int? timeSeconds,
    int? attemptNumber,
    String? source,
  }) {
    return logEvent(AnalyticsConfig.eventLevelFailed, {
      if (levelNumber != null) 'level_number': levelNumber,
      if (difficulty != null) 'difficulty': difficulty,
      if (moves != null) 'moves': moves,
      if (timeSeconds != null) 'time_seconds': timeSeconds,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (source != null) 'source': source,
    });
  }

  Future<void> logLevelAbandoned({
    int? levelNumber,
    String? difficulty,
    String? source,
  }) {
    return logEvent(AnalyticsConfig.eventLevelAbandoned, {
      if (levelNumber != null) 'level_number': levelNumber,
      if (difficulty != null) 'difficulty': difficulty,
      if (source != null) 'source': source,
    });
  }

  Future<void> logHintUsed({int? levelNumber, String? source}) {
    return logEvent(AnalyticsConfig.eventHintUsed, {
      if (levelNumber != null) 'level_number': levelNumber,
      if (source != null) 'source': source,
    });
  }

  Future<void> logRewardClaimed({String? rewardType, String? source}) {
    return logEvent(AnalyticsConfig.eventRewardClaimed, {
      if (rewardType != null) 'reward_type': rewardType,
      if (source != null) 'source': source,
    });
  }

  Future<void> logDailyRewardClaimed({int? day, String? source}) {
    return logEvent(AnalyticsConfig.eventDailyRewardClaimed, {
      if (day != null) 'day': day,
      if (source != null) 'source': source,
    });
  }

  Future<void> logNotificationOpened({
    String? notificationId,
    String? source,
  }) {
    return logEvent(AnalyticsConfig.eventNotificationOpened, {
      if (notificationId != null) 'notification_id': notificationId,
      if (source != null) 'source': source,
    });
  }

  Future<void> logNotificationScheduled({int? count, String? source}) {
    return logEvent(AnalyticsConfig.eventNotificationScheduled, {
      if (count != null) 'count': count,
      if (source != null) 'source': source,
    });
  }

  Future<void> logRewardedAdCompleted({String? placement, String? source}) {
    return logEvent(AnalyticsConfig.eventRewardedAdCompleted, {
      if (placement != null) 'placement': placement,
      if (source != null) 'source': source,
    });
  }

  Future<void> logScreen({required String name, String? source}) {
    return logEvent(AnalyticsConfig.eventScreenView, {
      'screen_name': name,
      if (source != null) 'source': source,
    });
  }

  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {
    if (!_config.enabled) return;
    try {
      final FirebaseAnalytics? analytics = _analytics;
      if (analytics == null) return;
      await analytics.logEvent(
        name: name,
        parameters: parameters == null ? null : _sanitize(parameters),
      );
    } catch (error, stack) {
      debugPrint('Analytics event "$name" failed: $error\n$stack');
    }
  }

  Map<String, Object> _sanitize(Map<String, Object> parameters) {
    const Set<String> blocked = <String>{
      'password',
      'email',
      'phone',
      'token',
      'auth',
      'payment',
      'card',
    };
    final Map<String, Object> out = <String, Object>{};
    for (final MapEntry<String, Object> entry in parameters.entries) {
      final String key = entry.key.toLowerCase();
      if (blocked.any(key.contains)) continue;
      final Object value = entry.value;
      if (value is String || value is num || value is bool) {
        out[entry.key] = value;
      } else {
        out[entry.key] = value.toString();
      }
    }
    return out;
  }
}
