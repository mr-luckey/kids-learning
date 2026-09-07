import 'package:flutter_test/flutter_test.dart';
import 'package:kids/core/config/ads_config.dart';
import 'package:kids/core/config/app_ads_config.dart';

void main() {
  group('AdsConfig placements', () {
    test('maps named placements to existing unit indexes', () {
      const AdsConfig config = AdsConfig(
        testMode: false,
        bannerAdUnits: <String>['banner-a', 'banner-b'],
        interstitialAdUnits: <String>['int-a', 'int-b'],
        rewardedAdUnits: <String>['rew-a'],
        bannerPlacements: <String, int>{'home': 0, 'quiz': 1},
        interstitialPlacements: <String, int>{
          'section_open': 0,
          'category_open': 1,
        },
        rewardedPlacements: <String, int>{'bonus_cheer': 0},
        rewardedEnabled: true,
      );

      expect(config.bannerUnitId('home'), 'banner-a');
      expect(config.bannerUnitId('quiz'), 'banner-b');
      expect(config.bannerUnitId('missing'), isNull);
      expect(config.interstitialUnitId('section_open'), 'int-a');
      expect(config.interstitialUnitId('category_open'), 'int-b');
      expect(config.rewardedUnitId('bonus_cheer'), 'rew-a');
    });

    test('production mode uses real unit IDs, not Google samples', () {
      expect(appAdsConfig.testMode, isFalse);
      expect(kUseTestAds, isFalse);
      expect(
        appAdsConfig.bannerUnitId('home'),
        'ca-app-pub-6619866004331477/8150969636',
      );
      expect(
        appAdsConfig.interstitialUnitId('section_open'),
        'ca-app-pub-6619866004331477/5751986677',
      );
      expect(
        appAdsConfig.rewardedUnitId('bonus_cheer'),
        'ca-app-pub-6619866004331477/5137793485',
      );
    });

    test('AdsConfig.testMode still returns Google sample IDs', () {
      const AdsConfig config = AdsConfig(
        testMode: true,
        bannerAdUnits: <String>['banner-prod'],
        interstitialAdUnits: <String>['int-prod'],
        rewardedAdUnits: <String>['rew-prod'],
        bannerPlacements: <String, int>{'home': 0},
        interstitialPlacements: <String, int>{'section_open': 0},
        rewardedPlacements: <String, int>{'bonus_cheer': 0},
        rewardedEnabled: true,
      );
      expect(
        config.bannerUnitId('home'),
        anyOf(
          GoogleTestAdUnits.androidBanner,
          GoogleTestAdUnits.iosBanner,
        ),
      );
      expect(
        config.interstitialUnitId('section_open'),
        anyOf(
          GoogleTestAdUnits.androidInterstitial,
          GoogleTestAdUnits.iosInterstitial,
        ),
      );
      expect(
        config.rewardedUnitId('bonus_cheer'),
        anyOf(
          GoogleTestAdUnits.androidRewarded,
          GoogleTestAdUnits.iosRewarded,
        ),
      );
    });

    test('production lists keep five units per format', () {
      expect(appAdsConfig.bannerAdUnits.length, 5);
      expect(appAdsConfig.interstitialAdUnits.length, 5);
      expect(appAdsConfig.rewardedAdUnits.length, 5);
      expect(appAdsConfig.rewardedEnabled, isTrue);
      expect(kAdMobAppId, 'ca-app-pub-6619866004331477~8984654672');
      expect(
        appAdsConfig.bannerAdUnits.first,
        startsWith('ca-app-pub-6619866004331477/'),
      );
    });
  });
}
