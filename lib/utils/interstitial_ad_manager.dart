import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  static final InterstitialAdManager _instance =
      InterstitialAdManager._internal();
  factory InterstitialAdManager() => _instance;
  InterstitialAdManager._internal();

  static InterstitialAd? _currentAd;
  static bool _isAdLoading = false;
  static int _currentAdIndex = 0;
  static bool _isAdShown = false;
  static DateTime? _lastAdShown;
  static const int _minAdInterval = 180; // Minimum 3 minutes between ads

  // Add your 10 ad unit IDs here
  static final List<String> _adUnitIds = [
    'ca-app-pub-5561438827097019/9820910070'
        'ca-app-pub-5561438827097019/2133991744'
        'ca-app-pub-5561438827097019/7138906414'
        'ca-app-pub-5561438827097019/8208445507'
        'ca-app-pub-5561438827097019/4760155089'
        'ca-app-pub-5561438827097019/1353864092',
    'ca-app-pub-5561438827097019/5780435518',
    'ca-app-pub-5561438827097019/6386940177',
    'ca-app-pub-5561438827097019/5073858504',
    'ca-app-pub-5561438827097019/3760776834',
    'ca-app-pub-5561438827097019/8163056276',
    'ca-app-pub-5561438827097019/5536892937',
    'ca-app-pub-5561438827097019/1025952228',
    'ca-app-pub-5561438827097019/6414619084',
    'ca-app-pub-5561438827097019/5101537414',
  ];

  void initialize() {
    _loadNextAd();
  }

  void _loadNextAd() {
    if (_isAdLoading) return;
    _isAdLoading = true;

    print('Loading interstitial ad with ID: ${_adUnitIds[_currentAdIndex]}');

    InterstitialAd.load(
      adUnitId: _adUnitIds[_currentAdIndex],
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('Interstitial ad loaded successfully');
          _currentAd = ad;
          _isAdLoading = false;
          _setupAdCallbacks();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: ${error.message}');
          _isAdLoading = false;
          _tryNextAd();
        },
      ),
    );
  }

  void _setupAdCallbacks() {
    _currentAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('Interstitial ad dismissed by user');
        ad.dispose();
        _currentAd = null;
        _isAdShown = false;
        _tryNextAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Interstitial ad failed to show: ${error.message}');
        ad.dispose();
        _currentAd = null;
        _isAdShown = false;
        _tryNextAd();
      },
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('Interstitial ad showed full screen content');
        _isAdShown = true;
        _lastAdShown = DateTime.now();
      },
      onAdImpression: (InterstitialAd ad) {
        print('Interstitial ad impression recorded');
      },
    );
  }

  void _tryNextAd() {
    _currentAdIndex = (_currentAdIndex + 1) % _adUnitIds.length;
    _loadNextAd();
  }

  bool isAdReady() {
    return _currentAd != null && !_isAdShown;
  }

  bool canShowAd() {
    if (_lastAdShown == null) return true;

    final timeSinceLastAd = DateTime.now().difference(_lastAdShown!).inSeconds;
    return timeSinceLastAd >= _minAdInterval;
  }

  void showAd(BuildContext context) {
    // Check if enough time has passed since last ad
    if (!canShowAd()) {
      final timeSinceLastAd =
          DateTime.now().difference(_lastAdShown!).inSeconds;
      final timeRemaining = _minAdInterval - timeSinceLastAd;
      print('Ad shown too recently. Please wait ${timeRemaining} seconds');
      return;
    }

    if (_currentAd != null && !_isAdShown) {
      print('Showing interstitial ad');
      _currentAd?.show();
    } else {
      print('No ad available to show');
      _loadNextAd();
    }
  }

  void dispose() {
    _currentAd?.dispose();
    _currentAd = null;
  }
}

// Custom interstitial ad widget with close button overlay
class CustomInterstitialAdWidget extends StatefulWidget {
  final InterstitialAd ad;
  final VoidCallback? onAdClosed;

  const CustomInterstitialAdWidget({
    Key? key,
    required this.ad,
    this.onAdClosed,
  }) : super(key: key);

  @override
  _CustomInterstitialAdWidgetState createState() =>
      _CustomInterstitialAdWidgetState();
}

class _CustomInterstitialAdWidgetState
    extends State<CustomInterstitialAdWidget> {
  bool _showCloseButton = false;
  bool _adShown = false;

  @override
  void initState() {
    super.initState();
    // Show close button after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showCloseButton = true;
        });
      }
    });

    // Show the actual interstitial ad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_adShown) {
        _showInterstitialAd();
      }
    });
  }

  void _showInterstitialAd() {
    if (!_adShown) {
      _adShown = true;
      widget.ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('Ad dismissed by user or automatically');
          _closeAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('Ad failed to show: ${error.message}');
          _closeAd();
        },
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          print('Ad showed full screen content');
        },
        onAdImpression: (InterstitialAd ad) {
          print('Ad impression recorded');
        },
      );
      widget.ad.show();
    }
  }

  void _closeAd() {
    widget.ad.dispose();
    widget.onAdClosed?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full screen ad content
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Loading Advertisement...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Close button - Always visible
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: _closeAd,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _showCloseButton ? Colors.red : Colors.black54,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          // Skip button at bottom
          Positioned(
            bottom: 50,
            right: 20,
            child: GestureDetector(
              onTap: _closeAd,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _showCloseButton ? Colors.red : Colors.grey,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  _showCloseButton ? 'Skip Ad' : 'Wait...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
