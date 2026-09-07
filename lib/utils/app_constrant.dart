// google ad ids

import 'dart:io';

import 'package:flutter/material.dart';

/// Flip to `true` to force Google sample/test ads everywhere ads load.
/// Set back to `false` before Play Store / production release.
const bool kUseTestAds = true;

// Production unit IDs (used only when [kUseTestAds] is false).
const String _androidProdBanner = 'ca-app-pub-5561438827097019/1372594672';
const String _androidProdInterstitial =
    'ca-app-pub-5561438827097019/6982824639'; // naseer id replaced

// Official Google sample / test unit IDs.
const String _androidTestBanner = 'ca-app-pub-3940256099942544/6300978111';
const String _androidTestInterstitial =
    'ca-app-pub-3940256099942544/1033173712';
const String _iosTestBanner = 'ca-app-pub-3940256099942544/2934735716';
const String _iosTestInterstitial = 'ca-app-pub-3940256099942544/4411468910';

String get android_Google_banner =>
    kUseTestAds ? _androidTestBanner : _androidProdBanner;

String get android_Google_interstitial =>
    kUseTestAds ? _androidTestInterstitial : _androidProdInterstitial;

String get ios_Google_banner => _iosTestBanner;

String get ios_Google_interstitial => _iosTestInterstitial;

/// Active banner unit for the current platform (respects [kUseTestAds]).
String get activeBannerAdUnitId {
  if (Platform.isIOS) return ios_Google_banner;
  return android_Google_banner;
}

/// Active interstitial unit for the current platform (respects [kUseTestAds]).
String get activeInterstitialAdUnitId {
  if (Platform.isIOS) return ios_Google_interstitial;
  return android_Google_interstitial;
}

/// Production interstitial placements (named slots — not a fill waterfall).
/// Used only when [kUseTestAds] is false.
const List<String> productionInterstitialAdUnits = <String>[
  'ca-app-pub-5561438827097019/9820910070',
  'ca-app-pub-5561438827097019/2133991744',
  'ca-app-pub-5561438827097019/7138906414',
  'ca-app-pub-5561438827097019/8208445507',
  'ca-app-pub-5561438827097019/4760155089',
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

/// Interstitial unit IDs currently active for loading.
List<String> get activeInterstitialAdUnitIds {
  if (kUseTestAds) return <String>[activeInterstitialAdUnitId];
  return productionInterstitialAdUnits;
}

// New kid-friendly palette (vibrant but soft)
const appcolor = Color(0xFF92EFA6);
const appBarStart = Color(0xFF6DD5ED);
const appBarEnd = Color(0xFF92EFA6);
const scaffoldBgStart = Color(0xFFFFF8F0);
const scaffoldBgEnd = Color(0xFFF0F9FF);
const cardShadowColor = Color(0x1A000000);

const videolearnBGcolor = Color(0xFFFFE5D9);
const videolearnTextColor = Color(0xFFE85D4C);
const LookAndChooesbgcolor = Color(0xFFFFF9E3);
const LookAndChooestextcolor = Color(0xFFD4A017);
const listenandgessbgcolor = Color(0xFFE8E0F0);
const listenandgessTextcolor = Color(0xFF6B5B95);
const LetsStartLearningbgcolor = Color(0xFFD4F5DC);
const LetsStartLearningTextColor = Color(0xFF2E7D32);
