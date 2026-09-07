import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/utils/app_constrant.dart';

/// Standard bottom-anchored AdMob banner.
/// Always sits flush at the screen bottom; collapses on no-fill.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Need MediaQuery width for anchored adaptive size.
    if (!_isLoaded && !_isLoading && _bannerAd == null) {
      _load();
    }
  }

  Future<void> _load() async {
    if (_isLoading) return;
    _isLoading = true;

    final int width = MediaQuery.of(context).size.width.truncate();
    final AnchoredAdaptiveBannerAdSize? adaptiveSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    if (!mounted) return;

    // Fall back to standard 320x50 if adaptive size is unavailable.
    final AdSize size = adaptiveSize ?? AdSize.banner;

    final BannerAd ad = BannerAd(
      adUnitId: activeBannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Banner failed to load: ${error.message}');
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _isLoaded = false;
              _isLoading = false;
            });
          }
        },
      ),
    );
    await ad.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BannerAd? ad = _bannerAd;
    if (!_isLoaded || ad == null) {
      // Zero height — do not reserve empty mid-screen space.
      return const SizedBox(width: double.infinity, height: 0);
    }

    // Fixed height is required: Center alone expands bottomNavigationBar
    // and makes the ad look like it is floating in the middle of the screen.
    return Material(
      color: Colors.white,
      elevation: 0,
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: SizedBox(
          width: double.infinity,
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
