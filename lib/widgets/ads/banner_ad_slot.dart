import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/services/ads_service.dart';

/// One on-screen banner placement. Collapses on no-fill. Disposes on leave.
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({
    Key? key,
    required this.ads,
    required this.placement,
    this.size,
    this.padding = const EdgeInsets.only(top: 8),
  }) : super(key: key);

  final AdsService ads;
  final String placement;
  final AdSize? size;
  final EdgeInsets padding;

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _loading = false;
  int _attempts = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ad == null && !_loaded && !_loading) {
      _load();
    }
  }

  Future<void> _load() async {
    if (_loading) return;
    _loading = true;
    _attempts++;

    AdSize size = widget.size ?? AdSize.banner;
    if (widget.size == null && mounted) {
      final int width = MediaQuery.of(context).size.width.truncate();
      final AnchoredAdaptiveBannerAdSize? adaptive =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
      size = adaptive ?? AdSize.banner;
    }

    final BannerAd? ad = await widget.ads.loadBanner(
      placement: widget.placement,
      size: size,
    );
    if (!mounted) {
      ad?.dispose();
      _loading = false;
      return;
    }

    if (ad == null && _attempts < 2) {
      _loading = false;
      // One delayed retry — covers SDK / network still warming up.
      await Future<void>.delayed(const Duration(seconds: 2));
      if (mounted && _ad == null && !_loaded) {
        await _load();
      }
      return;
    }

    setState(() {
      _ad = ad;
      _loaded = ad != null;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BannerAd? ad = _ad;
    if (!_loaded || ad == null) {
      return const SizedBox(width: double.infinity, height: 0);
    }
    return Material(
      color: Colors.white,
      elevation: 0,
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: Padding(
          padding: widget.padding,
          child: SizedBox(
            width: double.infinity,
            height: ad.size.height.toDouble(),
            child: AdWidget(ad: ad),
          ),
        ),
      ),
    );
  }
}
