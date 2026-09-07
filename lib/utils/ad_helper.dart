import 'package:flutter/material.dart';
import 'interstitial_ad_manager.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  final InterstitialAdManager _interstitialManager = InterstitialAdManager();

  void initialize() {
    _interstitialManager.initialize();
  }

  bool isAdReady() => _interstitialManager.isAdReady();

  bool canShowAd() => _interstitialManager.canShowAd();

  /// Shows a preloaded interstitial when ready and the min interval has passed.
  void showInterstitial() {
    if (_interstitialManager.isAdReady() && _interstitialManager.canShowAd()) {
      _interstitialManager.showAd();
    } else if (!_interstitialManager.isAdReady()) {
      // Keep a unit warm for the next natural break.
      _interstitialManager.ensureLoaded();
    }
  }

  @Deprecated('Use showInterstitial()')
  void showCustomInterstitialAd(BuildContext context) {
    showInterstitial();
  }

  void dispose() {
    _interstitialManager.dispose();
  }
}
