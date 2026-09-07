import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/utils/app_constrant.dart';

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
  static const int _minAdInterval = 30; // seconds between shows

  List<String> get _adUnitIds => activeInterstitialAdUnitIds;

  void initialize() {
    if (kUseTestAds) {
      print('AdMob test mode ON — using Google sample interstitial IDs');
    }
    _loadNextAd();
  }

  void _loadNextAd() {
    if (_isAdLoading) return;
    final List<String> ids = _adUnitIds;
    if (ids.isEmpty) return;

    _isAdLoading = true;
    final String unitId = ids[_currentAdIndex % ids.length];
    print('Loading interstitial ad with ID: $unitId');

    InterstitialAd.load(
      adUnitId: unitId,
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
          // Retry the same placement later — do not waterfall other unit IDs.
          Future<void>.delayed(const Duration(seconds: 30), () {
            if (_currentAd == null && !_isAdLoading) {
              _loadNextAd();
            }
          });
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
        _advancePlacementAndReload();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Interstitial ad failed to show: ${error.message}');
        ad.dispose();
        _currentAd = null;
        _isAdShown = false;
        _advancePlacementAndReload();
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

  /// After a successful show cycle, rotate to the next *named* placement index
  /// for the next preload (not a no-fill chase).
  void _advancePlacementAndReload() {
    final List<String> ids = _adUnitIds;
    if (ids.isEmpty) return;
    _currentAdIndex = (_currentAdIndex + 1) % ids.length;
    _loadNextAd();
  }

  bool isAdReady() {
    return _currentAd != null && !_isAdShown;
  }

  bool canShowAd() {
    if (_lastAdShown == null) return true;

    final int timeSinceLastAd =
        DateTime.now().difference(_lastAdShown!).inSeconds;
    return timeSinceLastAd >= _minAdInterval;
  }

  void showAd(BuildContext context) {
    if (!canShowAd()) {
      final int timeSinceLastAd =
          DateTime.now().difference(_lastAdShown!).inSeconds;
      final int timeRemaining = _minAdInterval - timeSinceLastAd;
      print('Ad shown too recently. Please wait $timeRemaining seconds');
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
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showCloseButton = true;
        });
      }
    });

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
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
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
