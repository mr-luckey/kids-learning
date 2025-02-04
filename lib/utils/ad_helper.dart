import 'dart:io' show Platform;
import 'app_constrant.dart';

class AdHelper {
  static int _currentInterstitialIndex = 0;

  // List of Android interstitial ad unit IDs
  static final List<String> _androidInterstitialIds = [
    'ca-app-pub-5561438827097019/6982824639', // Replace with your actual ad unit IDs
    'ca-app-pub-5561438827097019/9035699602',
    'ca-app-pub-5561438827097019/2661862941',
    'ca-app-pub-5561438827097019/7722617934',
    'ca-app-pub-5561438827097019/5315946447',
    'ca-app-pub-5561438827097019/5096454592',
    'ca-app-pub-5561438827097019/6593933749',
    'ca-app-pub-5561438827097019/5280852073',
    'ca-app-pub-5561438827097019/6047138831',
    // 'ca-app-pub-3940256099942544/1033173712',
    'ca-app-pub-5561438827097019/3420975491',
  ];

  // List of iOS interstitial ad unit IDs
  static final List<String> _iosInterstitialIds = [
    'ca-app-pub-XXXXX/ZZZZZ1', // Replace with your actual ad unit IDs
    'ca-app-pub-XXXXX/ZZZZZ2',
    'ca-app-pub-XXXXX/ZZZZZ3',
    'ca-app-pub-XXXXX/ZZZZZ4',
    'ca-app-pub-XXXXX/ZZZZZ5',
    'ca-app-pub-XXXXX/ZZZZZ6',
    'ca-app-pub-XXXXX/ZZZZZ7',
    'ca-app-pub-XXXXX/ZZZZZ8',
    'ca-app-pub-XXXXX/ZZZZZ9',
    'ca-app-pub-XXXXX/ZZZZZ10',
  ];

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return android_Google_banner;
    } else if (Platform.isIOS) {
      return ios_Google_banner;
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get interstitialAdUnitId {
    List<String> adIds;
    if (Platform.isAndroid) {
      adIds = _androidInterstitialIds;
    } else if (Platform.isIOS) {
      adIds = _iosInterstitialIds;
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    // Get current ID and increment counter
    String currentId = adIds[_currentInterstitialIndex];
    _currentInterstitialIndex = (_currentInterstitialIndex + 1) % adIds.length;
    return currentId;
  }

  // Reset the counter if needed
  static void resetInterstitialCounter() {
    _currentInterstitialIndex = 0;
  }

  // static String get rewardedAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-8749003959072354/2044115035';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-8749003959072354/7792061890';
  //   } else {
  //     throw new UnsupportedError('Unsupported platform');
  //   }
  // }
}
