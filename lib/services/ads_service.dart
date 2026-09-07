import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/core/config/ads_config.dart';
import 'package:kids/services/network_guard.dart';

enum RewardedAdOutcome { earned, skipped, unavailable }

/// Central AdMob manager. Placement-based IDs. No waterfall. Offline = idle.
class AdsService {
  AdsService({
    AdsConfig config = const AdsConfig(),
    NetworkGuard? network,
  })  : _config = config,
        _network = network ?? NetworkGuard();

  final AdsConfig _config;
  final NetworkGuard _network;

  bool _sdkInitialized = false;
  bool _initializing = false;
  Completer<bool>? _sdkCompleter;
  bool _fullScreenShowing = false;
  DateTime? _lastFullScreenAt;

  InterstitialAd? _interstitial;
  String? _interstitialPlacement;
  RewardedAd? _rewarded;
  String? _rewardedPlacement;

  int _interstitialAttempts = 0;
  int _rewardedAttempts = 0;
  Timer? _interstitialRetry;
  Timer? _rewardedRetry;

  bool get isReady => _sdkInitialized;
  bool get isOnline => _network.isOnline;
  bool get isFullScreenShowing => _fullScreenShowing;
  bool get hasRewardedAd => _rewarded != null;

  Future<void> start() async {
    await _network.start(onOnline: _onNetworkRestored);
    if (_network.isOnline) {
      await _ensureSdk();
    }
  }

  Future<void> dispose() async {
    _interstitialRetry?.cancel();
    _rewardedRetry?.cancel();
    _interstitial?.dispose();
    _rewarded?.dispose();
    _interstitial = null;
    _rewarded = null;
    await _network.dispose();
  }

  /// Load a banner for one visible placement. Caller owns dispose.
  Future<BannerAd?> loadBanner({
    required String placement,
    required AdSize size,
  }) async {
    final String? unitId = _config.bannerUnitId(placement);
    if (unitId == null) {
      debugPrint('Banner disabled/missing unit for [$placement]');
      return null;
    }
    if (!await _canUseAds()) {
      debugPrint('Banner skipped [$placement]: offline or SDK not ready');
      return null;
    }
    debugPrint('Loading banner [$placement] unit=$unitId');
    try {
      final Completer<BannerAd?> completer = Completer<BannerAd?>();
      final BannerAd ad = BannerAd(
        adUnitId: unitId,
        size: size,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad loaded) {
            if (!completer.isCompleted) completer.complete(loaded as BannerAd);
          },
          onAdFailedToLoad: (Ad failed, LoadAdError error) {
            debugPrint('Banner no-fill/fail [$placement]: $error');
            failed.dispose();
            if (!completer.isCompleted) completer.complete(null);
          },
        ),
      );
      await ad.load();
      return completer.future.timeout(
        _config.requestTimeout,
        onTimeout: () {
          ad.dispose();
          return null;
        },
      );
    } catch (error, stack) {
      debugPrint('loadBanner failed: $error\n$stack');
      return null;
    }
  }

  Future<void> preloadInterstitial({String placement = 'section_open'}) async {
    if (_interstitial != null && _interstitialPlacement == placement) return;
    final String? unitId = _config.interstitialUnitId(placement);
    if (unitId == null) return;
    if (!await _canUseAds()) return;
    if (_interstitialAttempts > _config.maxRetries) return;

    try {
      _interstitialRetry?.cancel();
      _interstitial?.dispose();
      _interstitial = null;
      final Completer<InterstitialAd?> completer = Completer<InterstitialAd?>();
      await InterstitialAd.load(
        adUnitId: unitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: completer.complete,
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('Interstitial no-fill/fail [$placement]: $error');
            if (!completer.isCompleted) completer.complete(null);
          },
        ),
      );
      final InterstitialAd? ad = await completer.future.timeout(
        _config.requestTimeout,
        onTimeout: () => null,
      );
      if (ad == null) {
        _interstitialAttempts++;
        _scheduleInterstitialRetry(placement);
        return;
      }
      _interstitialAttempts = 0;
      _interstitialPlacement = placement;
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (_) => _fullScreenShowing = true,
        onAdDismissedFullScreenContent: (InterstitialAd dismissed) {
          _fullScreenShowing = false;
          _lastFullScreenAt = DateTime.now();
          dismissed.dispose();
          _interstitial = null;
          // Reload the same placement only — never waterfall other IDs.
          unawaited(preloadInterstitial(placement: placement));
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd failed, AdError error) {
          debugPrint('Interstitial show failed: $error');
          _fullScreenShowing = false;
          failed.dispose();
          _interstitial = null;
        },
      );
      _interstitial = ad;
    } catch (error, stack) {
      debugPrint('preloadInterstitial failed: $error\n$stack');
    }
  }

  /// Natural-break interstitial. Returns false if skipped (frequency, no fill).
  Future<bool> showInterstitial({String placement = 'section_open'}) async {
    if (_fullScreenShowing) return false;
    if (!_frequencyAllowsInterstitial()) return false;
    if (_interstitial == null || _interstitialPlacement != placement) {
      await preloadInterstitial(placement: placement);
    }
    final InterstitialAd? ad = _interstitial;
    if (ad == null) return false;
    try {
      await ad.show();
      return true;
    } catch (error, stack) {
      debugPrint('showInterstitial failed: $error\n$stack');
      ad.dispose();
      _interstitial = null;
      return false;
    }
  }

  Future<void> preloadRewarded({String placement = 'hint'}) async {
    if (_rewarded != null && _rewardedPlacement == placement) return;
    final String? unitId = _config.rewardedUnitId(placement);
    if (unitId == null) return;
    if (!await _canUseAds()) return;
    if (_rewardedAttempts > _config.maxRetries) return;

    try {
      _rewardedRetry?.cancel();
      _rewarded?.dispose();
      _rewarded = null;
      final Completer<RewardedAd?> completer = Completer<RewardedAd?>();
      await RewardedAd.load(
        adUnitId: unitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: completer.complete,
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('Rewarded no-fill/fail [$placement]: $error');
            if (!completer.isCompleted) completer.complete(null);
          },
        ),
      );
      final RewardedAd? ad = await completer.future.timeout(
        _config.requestTimeout,
        onTimeout: () => null,
      );
      if (ad == null) {
        _rewardedAttempts++;
        _scheduleRewardedRetry(placement);
        return;
      }
      _rewardedAttempts = 0;
      _rewardedPlacement = placement;
      _rewarded = ad;
    } catch (error, stack) {
      debugPrint('preloadRewarded failed: $error\n$stack');
    }
  }

  /// User-initiated only. Grant a reward only when [RewardedAdOutcome.earned].
  Future<RewardedAdOutcome> showRewarded({String placement = 'hint'}) async {
    if (_fullScreenShowing) return RewardedAdOutcome.unavailable;
    if (_rewarded == null || _rewardedPlacement != placement) {
      await preloadRewarded(placement: placement);
    }
    final RewardedAd? ad = _rewarded;
    if (ad == null) return RewardedAdOutcome.unavailable;

    final Completer<RewardedAdOutcome> completer = Completer<RewardedAdOutcome>();
    bool earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => _fullScreenShowing = true,
      onAdDismissedFullScreenContent: (RewardedAd dismissed) {
        _fullScreenShowing = false;
        _lastFullScreenAt = DateTime.now();
        dismissed.dispose();
        _rewarded = null;
        if (!completer.isCompleted) {
          completer.complete(
            earned ? RewardedAdOutcome.earned : RewardedAdOutcome.skipped,
          );
        }
      },
      onAdFailedToShowFullScreenContent: (RewardedAd failed, AdError error) {
        debugPrint('Rewarded show failed: $error');
        _fullScreenShowing = false;
        failed.dispose();
        _rewarded = null;
        if (!completer.isCompleted) {
          completer.complete(RewardedAdOutcome.unavailable);
        }
      },
    );

    try {
      await ad.show(
        onUserEarnedReward: (_, __) {
          earned = true;
        },
      );
      return completer.future;
    } catch (error, stack) {
      debugPrint('showRewarded failed: $error\n$stack');
      ad.dispose();
      _rewarded = null;
      return RewardedAdOutcome.unavailable;
    }
  }

  void _onNetworkRestored() {
    _interstitialAttempts = 0;
    _rewardedAttempts = 0;
    unawaited(_ensureSdk());
    // Do not burst-load every placement. Callers load what is on screen.
  }

  Future<bool> _canUseAds() async {
    if (!_config.isEnabled) return false;
    if (!_network.isOnline) return false;
    return _ensureSdk();
  }

  Future<bool> _ensureSdk() async {
    if (_sdkInitialized) return true;
    if (!_network.isOnline || !_config.isEnabled) return false;
    // Wait for an in-flight init instead of returning false (banner race).
    final Completer<bool>? inFlight = _sdkCompleter;
    if (_initializing && inFlight != null) {
      return inFlight.future;
    }
    _initializing = true;
    final Completer<bool> completer = Completer<bool>();
    _sdkCompleter = completer;
    try {
      if (_config.testMode) {
        debugPrint('AdMob test mode ON — Google sample unit IDs');
      }
      await MobileAds.instance.initialize();
      _sdkInitialized = true;
    } catch (error, stack) {
      debugPrint('MobileAds.initialize failed: $error\n$stack');
      _sdkInitialized = false;
    } finally {
      _initializing = false;
      if (!completer.isCompleted) {
        completer.complete(_sdkInitialized);
      }
      if (identical(_sdkCompleter, completer)) {
        _sdkCompleter = null;
      }
    }
    return _sdkInitialized;
  }

  bool _frequencyAllowsInterstitial() {
    final DateTime? last = _lastFullScreenAt;
    if (last == null) return true;
    return DateTime.now().difference(last) >=
        _config.minimumInterstitialInterval;
  }

  void _scheduleInterstitialRetry(String placement) {
    if (!_network.isOnline) return;
    if (_interstitialAttempts > _config.maxRetries) return;
    _interstitialRetry?.cancel();
    final Duration delay = _config.retryBackoff * _interstitialAttempts;
    _interstitialRetry = Timer(delay, () {
      unawaited(preloadInterstitial(placement: placement));
    });
  }

  void _scheduleRewardedRetry(String placement) {
    if (!_network.isOnline) return;
    if (_rewardedAttempts > _config.maxRetries) return;
    _rewardedRetry?.cancel();
    final Duration delay = _config.retryBackoff * _rewardedAttempts;
    _rewardedRetry = Timer(delay, () {
      unawaited(preloadRewarded(placement: placement));
    });
  }
}
