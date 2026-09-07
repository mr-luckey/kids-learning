import 'package:flutter/material.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_3d_letter.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// Premium square category / lesson card — thick candy border, gloss,
/// bounce art, and a go-arrow chip.
class KidsEngagingCard extends StatelessWidget {
  final String label;
  final Color color;
  final String? imageAsset;
  final String? letter;
  final IconData? icon;
  final VoidCallback? onTap;
  final Duration bounceDelay;
  final double labelFontSize;

  const KidsEngagingCard({
    Key? key,
    required this.label,
    required this.color,
    this.imageAsset,
    this.letter,
    this.icon,
    this.onTap,
    this.bounceDelay = Duration.zero,
    this.labelFontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(28);

    return KidsBounce(
      delay: bounceDelay,
      offset: 5,
      scale: 0.018,
      child: KidsSquish(
        onTap: onTap,
        pressedScale: 0.92,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.white,
                Color.lerp(Colors.white, color, 0.22)!,
                Color.lerp(Colors.white, color, 0.38)!,
              ],
            ),
            borderRadius: radius,
            border: Border.all(color: color, width: 5),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: color.withOpacity(0.45),
                blurRadius: 0,
                spreadRadius: 3,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 54,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white.withOpacity(0.75),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Row(
                    children: List<Widget>.generate(3, (int i) {
                      return Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(left: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.35 + i * 0.15),
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: letter != null && Kids3DLetter.isLetter(letter)
                              ? Kids3DLetter(
                                  letter: letter!,
                                  size: 110,
                                  bounceDelay: bounceDelay,
                                )
                              : Image.asset(
                                  imageAsset ?? '',
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  errorBuilder: (_, __, ___) => Icon(
                                    icon ?? Icons.star_rounded,
                                    size: 72,
                                    color: color,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              color.withOpacity(0.92),
                              KidsTheme.darken(color, 0.12),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.85), width: 2),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: color.withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                label,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: KidsTheme.fontFamily,
                                  fontSize: labelFontSize.clamp(14, 20),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.1,
                                  shadows: const <Shadow>[
                                    Shadow(
                                      color: Color(0x66000000),
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating cartoon Rate-Us star character — not a wide bar button.
class KidsFloatingRateUs extends StatelessWidget {
  final VoidCallback onTap;

  const KidsFloatingRateUs({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsBounce(
      offset: 10,
      tilt: 0.06,
      scale: 0.04,
      child: KidsSquish(
        onTap: () {
          KidsSound.instance.sparkle();
          onTap();
        },
        child: SizedBox(
          width: 92,
          height: 110,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                top: 0,
                child: Image.asset(
                  'assets/ui/rate_star_3d.png',
                  width: 78,
                  height: 78,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.star_rounded,
                    size: 72,
                    color: KidsTheme.speakerYellow,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: KidsTheme.candyFill(KidsTheme.rateBlue),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: KidsTheme.pillowShadow(KidsTheme.rateBlue,
                        depth: 3),
                  ),
                  child: const Text(
                    'Rate us',
                    style: TextStyle(
                      fontFamily: KidsTheme.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KidsHubHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  const KidsHubHeader({
    Key? key,
    required this.title,
    this.onBack,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: <Widget>[
          KidsCircleNav.back(
            onTap: onBack ??
                () {
                  KidsSound.instance.whoosh();
                  Navigator.of(context).pop();
                },
          ),
          Expanded(
            child: KidsBubbleTitle(
              title,
              fontSize: title.contains('\n') ? 28 : 32,
              maxLines: 2,
              rimColor: Colors.white,
              fillColor: KidsTheme.bubbleFillBlue,
            ),
          ),
          trailing ?? const SizedBox(width: 56),
        ],
      ),
    );
  }
}
