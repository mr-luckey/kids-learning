import 'package:kids/core/config/ads_config.dart';

/// Flip to `false` for Play Store / App Store release builds.
/// When `true`, Google sample unit IDs are used regardless of lists below.
const bool kUseTestAds = false;

/// Production AdMob app ID (Android manifest / iOS Info.plist).
const String kAdMobAppId = 'ca-app-pub-6619866004331477~8984654672';

/// App AdMob config — production unit IDs from AdMob console (publisher
/// `6619866004331477`). Placement-based; no fill waterfall.
const AdsConfig appAdsConfig = AdsConfig(
  isEnabled: true,
  testMode: kUseTestAds,
  bannerEnabled: true,
  interstitialEnabled: true,
  rewardedEnabled: true,
  bannerAdUnits: <String>[
    'ca-app-pub-6619866004331477/8150969636', // Banner 1 — home
    'ca-app-pub-6619866004331477/2199754479', // Banner 2 — learning
    'ca-app-pub-6619866004331477/8781525023', // Banner 3 — quiz
    'ca-app-pub-6619866004331477/1390120160', // Banner 4 — video
    'ca-app-pub-6619866004331477/7468443354', // Banner 5 — settings
  ],
  interstitialAdUnits: <String>[
    'ca-app-pub-6619866004331477/5751986677', // Inter 1 — section_open
    'ca-app-pub-6619866004331477/4539027683', // Inter 2 — category_open
    'ca-app-pub-6619866004331477/4842280014', // Inter 3 — after_quiz
    'ca-app-pub-6619866004331477/3321264456', // Inter 4 — after_video
    'ca-app-pub-6619866004331477/1585561289', // Inter 5 — spare
  ],
  rewardedAdUnits: <String>[
    'ca-app-pub-6619866004331477/5137793485', // Reward 1 — bonus_cheer
    'ca-app-pub-6619866004331477/6530766203', // Reward 2 — support
    'ca-app-pub-6619866004331477/7068937774', // Reward 3
    'ca-app-pub-6619866004331477/9080907925', // Reward 4
    'ca-app-pub-6619866004331477/7572385130', // Reward 5
  ],
  bannerPlacements: <String, int>{
    'home': 0,
    'learning': 1,
    'quiz': 2,
    'video': 3,
    'settings': 4,
  },
  interstitialPlacements: <String, int>{
    'section_open': 0,
    'category_open': 1,
    'after_quiz': 2,
    'after_video': 3,
    'spare': 4,
  },
  rewardedPlacements: <String, int>{
    'bonus_cheer': 0,
    'support': 1,
    'play_again': 2,
  },
  minimumInterstitialInterval: Duration(minutes: 2),
  maxRetries: 2,
  retryBackoff: Duration(seconds: 30),
);
