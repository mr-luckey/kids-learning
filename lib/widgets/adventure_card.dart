import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// Back-compat candy card used by leftover screens (video lists, settings).
class AdventureCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final List<Color> gradientColors;
  final BorderRadius? borderRadius;

  const AdventureCard({
    Key? key,
    this.onTap,
    required this.child,
    required this.gradientColors,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color tint =
        gradientColors.isNotEmpty ? gradientColors.first : KidsTheme.skyTop;
    final BorderRadius radius =
        borderRadius ?? BorderRadius.circular(KidsTheme.radiusTile);

    return KidsBounce(
      child: KidsSquish(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: KidsTheme.softFill(tint),
            borderRadius: radius,
            border: Border.all(color: tint, width: 4),
            boxShadow: KidsTheme.pillowShadow(tint, depth: 5),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: child,
          ),
        ),
      ),
    );
  }
}

class AdventureText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign textAlign;

  const AdventureText({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsBubbleTitle(
      text,
      fontSize: fontSize,
      textAlign: textAlign,
      fillColor: KidsTheme.bubbleFill,
    );
  }
}

class AdventureTitle extends StatelessWidget {
  final String text;
  final double fontSize;

  const AdventureTitle({
    Key? key,
    required this.text,
    this.fontSize = 26,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsBubbleTitle(text, fontSize: fontSize);
  }
}
