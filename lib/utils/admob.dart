import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

// import 'ad_helper.dart';
// import 'app_constrant.dart';

class AdmobHelper {
  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;
  int _failedAttemptsCounter = 0;
  final int maxFailedLoadAttempts = 20; // Match with number of ad unit IDs

  // IsSilly _isSilly;
  static BannerAd getBannerAd() {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: '',
      listener: BannerAdListener(
        onAdClosed: (Ad ad) => debugPrint("Ad Closed"),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
        onAdLoaded: (Ad ad) => debugPrint('Ad Loaded'),
        onAdOpened: (Ad ad) => debugPrint('Ad opened'),
      ),
      request: const AdRequest(),
    );
  }

  // create interstitial ads
  void createInterad() {
    if (_isAdLoading) return;
    _isAdLoading = true;

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId, // Will get next ID from queue
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoading = false;
          _failedAttemptsCounter = 0; // Reset counter on successful load
          debugPrint('Interstitial ad loaded successfully');
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial ad failed to load: $error');
          _interstitialAd = null;
          _isAdLoading = false;
          _failedAttemptsCounter++;

          if (_failedAttemptsCounter < maxFailedLoadAttempts) {
            // Try next ID after a short delay
            Future.delayed(const Duration(milliseconds: 500), createInterad);
          } else {
            // Reset everything if all attempts failed
            _failedAttemptsCounter = 0;
            AdHelper.resetInterstitialCounter();
          }
        },
      ),
    );
  }

  void showInterad() {
    if (_interstitialAd == null) {
      debugPrint('Trying to show ad before loading');
      createInterad();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        debugPrint('Ad showed fullscreen content.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('Ad dismissed fullscreen content.');
        ad.dispose();
        createInterad(); // Load next ad from queue
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('Ad failed to show fullscreen content: $error');
        ad.dispose();
        createInterad(); // Try next ad from queue
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
