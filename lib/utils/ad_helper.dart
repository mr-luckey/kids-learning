import 'dart:io';
import 'app_constrant.dart';

class AdHelper {
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
    if (Platform.isAndroid) {
      return android_Google_interstitial;
    } else if (Platform.isIOS) {
      return ios_Google_interstitial;
    } else {
      throw UnsupportedError("unsupported Platform");
    }
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
