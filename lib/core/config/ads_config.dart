import 'package:flutter/foundation.dart';

/// Official Google sample units. Use only when [AdsConfig.testMode] is true.
class GoogleTestAdUnits {
  static const androidAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const iosAppId = 'ca-app-pub-3940256099942544~1458002511';

  static const androidBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const androidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const androidRewarded = 'ca-app-pub-3940256099942544/5224354917';

  static const iosBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const iosInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const iosRewarded = 'ca-app-pub-3940256099942544/1712485313';
}

/// Central AdMob configuration. Never invent production IDs.
///
/// Unit lists hold up to five IDs. Placements map a screen/feature name onto
/// one index. Empty strings disable that slot. There is no fill waterfall.
class AdsConfig {
  const AdsConfig({
    this.isEnabled = true,
    this.testMode = kDebugMode,
    this.bannerEnabled = true,
    this.interstitialEnabled = true,
    this.rewardedEnabled = true,
    this.bannerAdUnits = const [],
    this.interstitialAdUnits = const [],
    this.rewardedAdUnits = const [],
    this.bannerPlacements = const {'home': 0},
    this.interstitialPlacements = const {'after_session': 0},
    this.rewardedPlacements = const {'hint': 0},
    this.minimumInterstitialInterval = const Duration(minutes: 2),
    this.maxRetries = 2,
    this.retryBackoff = const Duration(seconds: 30),
    this.requestTimeout = const Duration(seconds: 10),
  });

  final bool isEnabled;
  final bool testMode;
  final bool bannerEnabled;
  final bool interstitialEnabled;
  final bool rewardedEnabled;

  final List<String> bannerAdUnits;
  final List<String> interstitialAdUnits;
  final List<String> rewardedAdUnits;

  /// Placement name → index into the matching unit list.
  final Map<String, int> bannerPlacements;
  final Map<String, int> interstitialPlacements;
  final Map<String, int> rewardedPlacements;

  final Duration minimumInterstitialInterval;
  final int maxRetries;
  final Duration retryBackoff;
  final Duration requestTimeout;

  String? bannerUnitId(String placement) =>
      _unit(bannerAdUnits, bannerPlacements[placement], bannerEnabled, _AdFormat.banner);

  String? interstitialUnitId(String placement) => _unit(
        interstitialAdUnits,
        interstitialPlacements[placement],
        interstitialEnabled,
        _AdFormat.interstitial,
      );

  String? rewardedUnitId(String placement) => _unit(
        rewardedAdUnits,
        rewardedPlacements[placement],
        rewardedEnabled,
        _AdFormat.rewarded,
      );

  String? _unit(
    List<String> units,
    int? index,
    bool enabled,
    _AdFormat format,
  ) {
    if (!isEnabled || !enabled || index == null || index < 0) return null;
    if (testMode) return _testIdFor(format);
    if (index >= units.length) return null;
    final String id = units[index].trim();
    return id.isEmpty ? null : id;
  }

  String _testIdFor(_AdFormat format) {
    final bool ios = defaultTargetPlatform == TargetPlatform.iOS;
    switch (format) {
      case _AdFormat.banner:
        return ios ? GoogleTestAdUnits.iosBanner : GoogleTestAdUnits.androidBanner;
      case _AdFormat.interstitial:
        return ios
            ? GoogleTestAdUnits.iosInterstitial
            : GoogleTestAdUnits.androidInterstitial;
      case _AdFormat.rewarded:
        return ios
            ? GoogleTestAdUnits.iosRewarded
            : GoogleTestAdUnits.androidRewarded;
    }
  }
}

enum _AdFormat { banner, interstitial, rewarded }
