// import 'dart:io' show Platform;
// import 'app_constrant.dart';

// class AdHelper {
//   static int _currentInterstitialIndex = 0;

//   // List of Android interstitial ad unit IDs
//   static final List<String> _androidInterstitialIds = [
//     'ca-app-pub-5561438827097019/6982824639', // Replace with your actual ad unit IDs
//     'ca-app-pub-5561438827097019/9035699602',
//     'ca-app-pub-5561438827097019/2661862941',
//     'ca-app-pub-5561438827097019/7722617934',
//     'ca-app-pub-5561438827097019/5315946447',
//     'ca-app-pub-5561438827097019/5096454592',
//     'ca-app-pub-5561438827097019/6593933749',
//     'ca-app-pub-5561438827097019/5280852073',
//     'ca-app-pub-5561438827097019/6047138831',
//     // 'ca-app-pub-3940256099942544/1033173712',
//     'ca-app-pub-5561438827097019/3420975491',
//   ];

//   // List of iOS interstitial ad unit IDs
//   static final List<String> _iosInterstitialIds = [
//     'ca-app-pub-XXXXX/ZZZZZ1', // Replace with your actual ad unit IDs
//     'ca-app-pub-XXXXX/ZZZZZ2',
//     'ca-app-pub-XXXXX/ZZZZZ3',
//     'ca-app-pub-XXXXX/ZZZZZ4',
//     'ca-app-pub-XXXXX/ZZZZZ5',
//     'ca-app-pub-XXXXX/ZZZZZ6',
//     'ca-app-pub-XXXXX/ZZZZZ7',
//     'ca-app-pub-XXXXX/ZZZZZ8',
//     'ca-app-pub-XXXXX/ZZZZZ9',
//     'ca-app-pub-XXXXX/ZZZZZ10',
//   ];

//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return android_Google_banner;
//     } else if (Platform.isIOS) {
//       return ios_Google_banner;
//     } else {
//       throw UnsupportedError("unsupported Platform");
//     }
//   }

//   static String get interstitialAdUnitId {
//     List<String> adIds;
//     if (Platform.isAndroid) {
//       adIds = _androidInterstitialIds;
//     } else if (Platform.isIOS) {
//       adIds = _iosInterstitialIds;
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }

//     // Get current ID and increment counter
//     String currentId = adIds[_currentInterstitialIndex];
//     _currentInterstitialIndex = (_currentInterstitialIndex + 1) % adIds.length;
//     return currentId;
//   }

//   // Reset the counter if needed
//   static void resetInterstitialCounter() {
//     _currentInterstitialIndex = 0;
//   }

//   // static String get rewardedAdUnitId {
//   //   if (Platform.isAndroid) {
//   //     return 'ca-app-pub-8749003959072354/2044115035';
//   //   } else if (Platform.isIOS) {
//   //     return 'ca-app-pub-8749003959072354/7792061890';
//   //   } else {
//   //     throw new UnsupportedError('Unsupported platform');
//   //   }
//   // }
// }
import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  static InterstitialAd? _currentAd;
  static bool _isAdLoading = false;
  static int _currentAdIndex = 0;
  static Timer? _adTimer;
  static bool _isAdShown = false;

  // Add your 10 ad unit IDs here
  static final List<String> _adUnitIds = [
    'ca-app-pub-5561438827097019/1353864092',
    'ca-app-pub-5561438827097019/5780435518',
    'ca-app-pub-5561438827097019/6386940177',
    'ca-app-pub-5561438827097019/5073858504',
    'ca-app-pub-5561438827097019/3760776834',
    'ca-app-pub-5561438827097019/8163056276',
    'ca-app-pub-5561438827097019/5536892937',
    'ca-app-pub-5561438827097019/1025952228',
    'ca-app-pub-5561438827097019/6414619084',
    'ca-app-pub-5561438827097019/5101537414', // Add your remaining ad IDs here
  ];

  void initialize() {
    _startAdTimer();
    _loadNextAd();
  }

  void _startAdTimer() {
    _adTimer?.cancel();
    _adTimer = Timer.periodic(const Duration(seconds: 2000), (timer) {
      if (!_isAdShown && _currentAd != null) {
        _showAd();
      } else if (!_isAdShown) {
        _loadNextAd();
      }
    });
  }

  void _loadNextAd() {
    if (_isAdLoading) return;
    _isAdLoading = true;

    InterstitialAd.load(
      adUnitId: _adUnitIds[_currentAdIndex],
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _currentAd = ad;
          _isAdLoading = false;
          _setupAdCallbacks();
          // Show ad immediately after loading
          _showAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Ad failed to load: ${error.message}');
          _isAdLoading = false;
          _tryNextAd();
        },
      ),
    );
  }

  void _setupAdCallbacks() {
    _currentAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _currentAd = null;
        _isAdShown = false;
        _tryNextAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Ad failed to show: ${error.message}');
        ad.dispose();
        _currentAd = null;
        _isAdShown = false;
        _tryNextAd();
      },
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        _isAdShown = true;
      },
    );
  }

  void _tryNextAd() {
    _currentAdIndex = (_currentAdIndex + 1) % _adUnitIds.length;
    _loadNextAd();
  }

  void _showAd() {
    if (_currentAd != null && !_isAdShown) {
      _currentAd?.show();
    }
  }

  void dispose() {
    _adTimer?.cancel();
    _currentAd?.dispose();
  }
}
