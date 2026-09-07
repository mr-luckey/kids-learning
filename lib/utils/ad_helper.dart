import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kids/services/app_services.dart';

/// Thin facade kept for existing call sites. Prefer [AppServices.ads] for new code.
class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  void initialize() {
    // Ads bootstrap lives in [AppServices.start]. Kept for call-site compatibility.
  }

  bool isAdReady() => AppServices.ads.isReady;

  bool canShowAd() => !AppServices.ads.isFullScreenShowing;

  /// Shows a preloaded interstitial for a named placement when frequency allows.
  void showInterstitial({String placement = 'section_open'}) {
    unawaited(AppServices.ads.showInterstitial(placement: placement));
  }

  @Deprecated('Use showInterstitial()')
  void showCustomInterstitialAd(BuildContext context) {
    showInterstitial();
  }

  void dispose() {
    unawaited(AppServices.ads.dispose());
  }
}
