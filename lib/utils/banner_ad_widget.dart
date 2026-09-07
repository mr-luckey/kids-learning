import 'package:flutter/material.dart';
import 'package:kids/services/app_services.dart';
import 'package:kids/widgets/ads/banner_ad_slot.dart';

/// Standard bottom-anchored AdMob banner for existing screens.
/// Collapses on no-fill / offline. Uses the shared [AppServices.ads] instance.
class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({
    Key? key,
    this.placement = 'home',
  }) : super(key: key);

  final String placement;

  @override
  Widget build(BuildContext context) {
    return BannerAdSlot(
      ads: AppServices.ads,
      placement: placement,
    );
  }
}
