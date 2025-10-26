import 'dart:async';
import 'package:flutter/material.dart';
import 'interstitial_ad_manager.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  static Timer? _adTimer;
  final InterstitialAdManager _interstitialManager = InterstitialAdManager();

  void initialize() {
    _interstitialManager.initialize();
    _startAdTimer();
  }

  void _startAdTimer() {
    _adTimer?.cancel();
    // Show ads every 5 minutes (300 seconds)
    _adTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_interstitialManager.isAdReady() &&
          _interstitialManager.canShowAd()) {
        // Note: Automatic ads will be handled by the InterstitialAdManager
        print(
            'Automatic ad timer triggered - ad will show when user navigates');
      }
    });
  }

  // Method to check if ad is ready
  bool isAdReady() {
    return _interstitialManager.isAdReady();
  }

  // Method to check if enough time has passed since last ad
  bool canShowAd() {
    return _interstitialManager.canShowAd();
  }

  // Method to show ad with close button functionality
  void showCustomInterstitialAd(BuildContext context) {
    if (_interstitialManager.isAdReady() && _interstitialManager.canShowAd()) {
      print('Showing custom interstitial ad with close button');
      _interstitialManager.showAd(context);
    } else {
      print('Ad not ready or shown too recently');
    }
  }

  void dispose() {
    _adTimer?.cancel();
    _interstitialManager.dispose();
  }
}
