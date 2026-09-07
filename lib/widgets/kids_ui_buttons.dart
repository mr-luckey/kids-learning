import 'package:flutter/material.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';

// ===========================================================================
// Shared building blocks
// ===========================================================================

/// Glossy sheen laid over a surface to sell the "3D candy" look.
class _Gloss extends StatelessWidget {
  final BorderRadius? radius;
  final bool circle;

  const _Gloss({Key? key, this.radius, this.circle = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: circle ? KidsTheme.circleGloss : KidsTheme.glossSheen,
            borderRadius: circle ? null : radius,
            shape: circle ? BoxShape.circle : BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}

/// Renders an asset image, falling back to an icon (and then to a coloured
/// dot) so a missing artwork file never shows a grey error box to a child.
class _KidsArt extends StatelessWidget {
  final String? asset;
  final IconData? icon;
  final double size;
  final Color tint;

  const _KidsArt({
    Key? key,
    this.asset,
    this.icon,
    required this.size,
    required this.tint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (asset != null && asset!.isNotEmpty) {
      return Image.asset(
        asset!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
          return _fallback();
        },
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Icon(
      icon ?? Icons.star_rounded,
      size: size * 0.8,
      color: tint,
    );
  }
}

// ===========================================================================
// A) KidsCategoryPill
// ===========================================================================

/// Horizontal category card from the mockup: a fat rounded rectangle with a
/// coloured border, artwork on the left, the label in the middle and a small
/// circular "go" arrow on the right.
class KidsCategoryPill extends StatelessWidget {
  final String label;

  /// Artwork shown in the leading circle.
  final String? imageAsset;

  /// Fallback / alternative to [imageAsset].
  final IconData? icon;

  /// Border + accent colour. Use `KidsTheme.categoryColor('Animals')`.
  final Color borderColor;

  final VoidCallback? onTap;

  final double height;
  final EdgeInsetsGeometry margin;

  /// Shows the trailing circular arrow.
  final bool showGoButton;

  /// Idle float. Stagger a list with [bounceDelay].
  final bool bounce;
  final Duration bounceDelay;

  final double labelFontSize;

  const KidsCategoryPill({
    Key? key,
    required this.label,
    required this.borderColor,
    this.imageAsset,
    this.icon,
    this.onTap,
    this.height = 92,
    this.margin = const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
    this.showGoButton = true,
    this.bounce = false,
    this.bounceDelay = Duration.zero,
    this.labelFontSize = 26,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color ink = KidsTheme.darken(KidsTheme.saturate(borderColor), 0.26);
    final BorderRadius radius =
        BorderRadius.circular(KidsTheme.radiusPillLarge);
    final double artSize = height * 0.60;

    Widget pill = Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: KidsTheme.softFill(borderColor, strength: 0.22),
        borderRadius: radius,
        border: Border.all(color: borderColor, width: 4),
        boxShadow: KidsTheme.pillowShadow(borderColor, depth: 4),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          _Gloss(radius: radius),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
            child: Row(
              children: <Widget>[
                // Leading artwork bubble.
                Container(
                  width: height * 0.74,
                  height: height * 0.74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: borderColor.withOpacity(0.45),
                      width: 3,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: borderColor.withOpacity(0.28),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: _KidsArt(
                    asset: imageAsset,
                    icon: icon,
                    size: artSize,
                    tint: borderColor,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: KidsTheme.label(
                      fontSize: labelFontSize,
                      color: ink,
                    ),
                  ),
                ),
                if (showGoButton) ...<Widget>[
                  const SizedBox(width: 10),
                  _GoCircle(color: borderColor, diameter: height * 0.46),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (bounce) {
      pill = KidsBounce(delay: bounceDelay, offset: 4, scale: 0.008, child: pill);
    }

    return KidsSquish(
      onTap: onTap,
      pressedScale: 0.955,
      child: pill,
    );
  }
}

/// Small glossy circle with a white chevron, used inside [KidsCategoryPill].
class _GoCircle extends StatelessWidget {
  final Color color;
  final double diameter;

  const _GoCircle({Key? key, required this.color, required this.diameter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: KidsTheme.candyFill(color),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: KidsTheme.darken(color, 0.24).withOpacity(0.7),
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const _Gloss(circle: true),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: diameter * 0.44,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// B) KidsHomeTile
// ===========================================================================

/// Big square home-screen tile: glossy coloured card, large artwork and a
/// bubble label. Drop these straight into a `GridView` with a 1.0 aspect
/// ratio, or give an explicit [size].
class KidsHomeTile extends StatelessWidget {
  final String label;

  /// Tile colour, e.g. [KidsTheme.tileStartLearning].
  final Color color;

  final String? imageAsset;
  final IconData? icon;
  final VoidCallback? onTap;

  /// Fixed square side. Null lets the parent (grid cell) decide.
  final double? size;

  final double labelFontSize;

  /// `true` floats the label on a frosted pill inside the tile, `false`
  /// places a bubble title underneath it.
  final bool labelInside;

  final bool bounce;
  final Duration bounceDelay;

  const KidsHomeTile({
    Key? key,
    required this.label,
    required this.color,
    this.imageAsset,
    this.icon,
    this.onTap,
    this.size,
    this.labelFontSize = 22,
    this.labelInside = true,
    this.bounce = true,
    this.bounceDelay = Duration.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(KidsTheme.radiusTile);

    final Widget card = Container(
      decoration: BoxDecoration(
        gradient: KidsTheme.candyFill(color),
        borderRadius: radius,
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 5),
        boxShadow: KidsTheme.pillowShadow(color, depth: 6),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          _Gloss(radius: radius),
          Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              14,
              12,
              labelInside ? 62 : 14,
            ),
            child: Center(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double art = constraints.biggest.shortestSide;
                  return _KidsArt(
                    asset: imageAsset,
                    icon: icon,
                    size: art.isFinite && art > 0 ? art : 72,
                    tint: Colors.white,
                  );
                },
              ),
            ),
          ),
          if (labelInside)
            Positioned(
              left: 10,
              right: 10,
              bottom: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.28),
                  borderRadius:
                      BorderRadius.circular(KidsTheme.radiusPillSmall),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6),
                    width: 2,
                  ),
                ),
                child: KidsBubbleTitle(
                  label,
                  fontSize: labelFontSize,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  outlineColor: KidsTheme.darken(color, 0.34),
                  shadowBlur: 4,
                ),
              ),
            ),
        ],
      ),
    );

    Widget tile = labelInside
        ? card
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: card),
              const SizedBox(height: 8),
              KidsBubbleTitle(
                label,
                fontSize: labelFontSize,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );

    if (size != null) {
      tile = SizedBox(width: size, height: size, child: tile);
    }

    if (bounce) {
      tile = KidsBounce(
        delay: bounceDelay,
        offset: 5,
        scale: 0.012,
        child: tile,
      );
    }

    return KidsSquish(onTap: onTap, pressedScale: 0.93, child: tile);
  }
}

// ===========================================================================
// C) KidsCircleNav
// ===========================================================================

enum KidsNavDirection { back, previous, next, up, down, home, close }

/// Round glossy navigation button — orange for prev/next, blue for back.
class KidsCircleNav extends StatelessWidget {
  final KidsNavDirection direction;
  final VoidCallback? onTap;

  /// Overrides the direction's default colour.
  final Color? color;

  /// Overrides the direction's default icon.
  final IconData? icon;

  final double size;

  /// Slow attention pulse. Handy on the "next" button of a lesson.
  final bool pulse;

  final bool enabled;

  /// Optional caption rendered under the circle.
  final String? label;

  const KidsCircleNav({
    Key? key,
    required this.direction,
    this.onTap,
    this.color,
    this.icon,
    this.size = 62,
    this.pulse = false,
    this.enabled = true,
    this.label,
  }) : super(key: key);

  const KidsCircleNav.back({
    Key? key,
    this.onTap,
    this.color,
    this.icon,
    this.size = 56,
    this.enabled = true,
    this.label,
  })  : direction = KidsNavDirection.back,
        pulse = false,
        super(key: key);

  const KidsCircleNav.next({
    Key? key,
    this.onTap,
    this.color,
    this.icon,
    this.size = 62,
    this.pulse = true,
    this.enabled = true,
    this.label,
  })  : direction = KidsNavDirection.next,
        super(key: key);

  const KidsCircleNav.previous({
    Key? key,
    this.onTap,
    this.color,
    this.icon,
    this.size = 62,
    this.pulse = false,
    this.enabled = true,
    this.label,
  })  : direction = KidsNavDirection.previous,
        super(key: key);

  Color get _defaultColor {
    switch (direction) {
      case KidsNavDirection.back:
      case KidsNavDirection.close:
        return KidsTheme.backBlue;
      case KidsNavDirection.home:
        return KidsTheme.tileStartLearning;
      case KidsNavDirection.previous:
      case KidsNavDirection.next:
      case KidsNavDirection.up:
      case KidsNavDirection.down:
        return KidsTheme.navOrange;
    }
  }

  IconData get _defaultIcon {
    switch (direction) {
      case KidsNavDirection.back:
        return Icons.arrow_back_rounded;
      case KidsNavDirection.close:
        return Icons.close_rounded;
      case KidsNavDirection.home:
        return Icons.home_rounded;
      case KidsNavDirection.previous:
        return Icons.chevron_left_rounded;
      case KidsNavDirection.next:
        return Icons.chevron_right_rounded;
      case KidsNavDirection.up:
        return Icons.keyboard_arrow_up_rounded;
      case KidsNavDirection.down:
        return Icons.keyboard_arrow_down_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color base = enabled
        ? (color ?? _defaultColor)
        : const Color(0xFFBFCBD6);

    Widget circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: KidsTheme.candyFill(base),
        border: Border.all(color: Colors.white.withOpacity(0.92), width: 4),
        boxShadow: KidsTheme.pillowShadow(base, depth: 4),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const _Gloss(circle: true),
          Icon(
            icon ?? _defaultIcon,
            size: size * 0.50,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                color: KidsTheme.darken(base, 0.3).withOpacity(0.6),
                offset: const Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          ),
        ],
      ),
    );

    if (pulse && enabled) {
      circle = KidsPulse(
        maxScale: 1.07,
        glowColor: base,
        child: circle,
      );
    }

    Widget button = KidsSquish(
      onTap: enabled ? onTap : null,
      pressedScale: 0.88,
      child: circle,
    );

    if (label != null) {
      button = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          button,
          const SizedBox(height: 6),
          KidsBubbleTitle(label!, fontSize: 15, strokeWidth: 3),
        ],
      );
    }

    return Opacity(opacity: enabled ? 1.0 : 0.6, child: button);
  }
}

// ===========================================================================
// D) KidsSpeakerButton
// ===========================================================================

/// Big yellow speaker. Always pulsing, because "tap me to hear it" is the
/// core loop of the app.
class KidsSpeakerButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final Color color;

  /// Set while audio/TTS is playing — pulses faster and swaps the icon.
  final bool isPlaying;

  /// Plays the short speaker cue before [onTap].
  final bool playCue;

  final bool pulse;

  const KidsSpeakerButton({
    Key? key,
    this.onTap,
    this.size = 78,
    this.color = KidsTheme.speakerYellow,
    this.isPlaying = false,
    this.playCue = true,
    this.pulse = true,
  }) : super(key: key);

  void _handleTap() {
    if (playCue) KidsSound.instance.speak();
    if (onTap != null) onTap!();
  }

  @override
  Widget build(BuildContext context) {
    Widget circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: KidsTheme.candyFill(color),
        border: Border.all(color: Colors.white.withOpacity(0.95), width: 5),
        boxShadow: KidsTheme.pillowShadow(color, depth: 5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const _Gloss(circle: true),
          Icon(
            isPlaying ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
            size: size * 0.46,
            color: const Color(0xFF7A4E00),
          ),
        ],
      ),
    );

    if (pulse) {
      circle = KidsPulse(
        duration: isPlaying
            ? const Duration(milliseconds: 520)
            : KidsTheme.pulseDuration,
        maxScale: isPlaying ? 1.10 : 1.07,
        glowColor: color,
        child: circle,
      );
    }

    return KidsSquish(
      onTap: onTap == null ? null : _handleTap,
      playSound: false,
      pressedScale: 0.88,
      child: circle,
    );
  }
}

// ===========================================================================
// E) KidsPrimaryCta
// ===========================================================================

/// Wide orange "Next Question" bar with a trailing arrow bubble.
class KidsPrimaryCta extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final IconData icon;

  /// `null` stretches to the parent width.
  final double? width;
  final double height;
  final double fontSize;

  /// Draws the trailing arrow bubble.
  final bool showArrow;

  /// Optional leading icon bubble.
  final IconData? leadingIcon;

  final bool pulse;
  final bool enabled;

  const KidsPrimaryCta({
    Key? key,
    this.label = 'Next Question',
    this.onTap,
    this.color = KidsTheme.nextOrange,
    this.icon = Icons.arrow_forward_rounded,
    this.width,
    this.height = 68,
    this.fontSize = 26,
    this.showArrow = true,
    this.leadingIcon,
    this.pulse = true,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color base = enabled ? color : const Color(0xFFC3CCD5);
    final BorderRadius radius =
        BorderRadius.circular(KidsTheme.radiusPillLarge);
    final double bubble = height * 0.62;

    Widget bar = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: KidsTheme.candyFill(base),
        borderRadius: radius,
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 4),
        boxShadow: KidsTheme.pillowShadow(base, depth: 5),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          _Gloss(radius: radius),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.22 + bubble),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: KidsTheme.labelOnColor(fontSize: fontSize),
            ),
          ),
          if (leadingIcon != null)
            Positioned(
              left: height * 0.12,
              child: _IconBubble(
                icon: leadingIcon!,
                diameter: bubble,
                color: base,
              ),
            ),
          if (showArrow)
            Positioned(
              right: height * 0.12,
              child: _IconBubble(icon: icon, diameter: bubble, color: base),
            ),
        ],
      ),
    );

    if (pulse && enabled) {
      bar = KidsPulse(
        maxScale: 1.035,
        glowColor: base,
        glowRadius: radius,
        child: bar,
      );
    }

    return KidsSquish(
      onTap: enabled ? onTap : null,
      pressedScale: 0.96,
      child: bar,
    );
  }
}

/// White circular icon chip used inside the wide CTA bars.
class _IconBubble extends StatelessWidget {
  final IconData icon;
  final double diameter;
  final Color color;

  const _IconBubble({
    Key? key,
    required this.icon,
    required this.diameter,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: KidsTheme.darken(color, 0.3).withOpacity(0.35),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: diameter * 0.56,
        color: KidsTheme.darken(color, 0.16),
      ),
    );
  }
}

// ===========================================================================
// F) KidsRateButton
// ===========================================================================

/// Wide blue "Rate us" bar with a gold star.
class KidsRateButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final double? width;
  final double height;
  final double fontSize;

  /// Shows five small stars on the right instead of a single trailing arrow.
  final bool showStarRow;

  final bool pulse;

  const KidsRateButton({
    Key? key,
    this.label = 'Rate us',
    this.onTap,
    this.color = KidsTheme.rateBlue,
    this.width,
    this.height = 62,
    this.fontSize = 24,
    this.showStarRow = true,
    this.pulse = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius =
        BorderRadius.circular(KidsTheme.radiusPillLarge);
    final double bubble = height * 0.62;

    Widget bar = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: KidsTheme.candyFill(color),
        borderRadius: radius,
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 4),
        boxShadow: KidsTheme.pillowShadow(color, depth: 5),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          _Gloss(radius: radius),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.22 + bubble),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: KidsTheme.labelOnColor(fontSize: fontSize),
            ),
          ),
          Positioned(
            left: height * 0.12,
            child: Container(
              width: bubble,
              height: bubble,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.star_rounded,
                size: bubble * 0.66,
                color: const Color(0xFFFFC93C),
              ),
            ),
          ),
          if (showStarRow)
            Positioned(
              right: height * 0.14,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(
                  3,
                  (int i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Icon(
                      Icons.star_rounded,
                      size: fontSize * 0.82,
                      color: const Color(0xFFFFE08A),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (pulse) {
      bar = KidsPulse(
        maxScale: 1.03,
        glowColor: color,
        glowRadius: radius,
        child: bar,
      );
    }

    return KidsSquish(onTap: onTap, pressedScale: 0.96, child: bar);
  }
}

// ===========================================================================
// G) KidsQuizOption
// ===========================================================================

enum KidsOptionState { idle, selected, correct, wrong }

/// White rounded answer tile for image or text options.
///
/// Feedback is driven entirely by [state]: switching to
/// [KidsOptionState.wrong] plays the soft wrong sound and shakes the tile,
/// while [KidsOptionState.correct] stamps a green check badge.
class KidsQuizOption extends StatefulWidget {
  final VoidCallback? onTap;

  final String? imageAsset;
  final IconData? icon;

  /// Text answer. Rendered large and centred when there is no artwork.
  final String? label;

  /// Fully custom content, wins over [imageAsset]/[label].
  final Widget? child;

  final KidsOptionState state;

  /// Fixed square side. Null lets the parent decide.
  final double? size;

  final double fontSize;
  final EdgeInsetsGeometry padding;

  /// Accent used for the idle border/tint.
  final Color accent;

  /// Disables taps without dimming the tile (e.g. after the answer is locked).
  final bool enabled;

  const KidsQuizOption({
    Key? key,
    this.onTap,
    this.imageAsset,
    this.icon,
    this.label,
    this.child,
    this.state = KidsOptionState.idle,
    this.size,
    this.fontSize = 34,
    this.padding = const EdgeInsets.all(12),
    this.accent = KidsTheme.backBlue,
    this.enabled = true,
  }) : super(key: key);

  @override
  _KidsQuizOptionState createState() => _KidsQuizOptionState();
}

class _KidsQuizOptionState extends State<KidsQuizOption> {
  int _shakeTrigger = 0;

  @override
  void didUpdateWidget(covariant KidsQuizOption oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == KidsOptionState.wrong &&
        oldWidget.state != KidsOptionState.wrong) {
      _shakeTrigger++;
    }
    if (widget.state == KidsOptionState.correct &&
        oldWidget.state != KidsOptionState.correct) {
      KidsSound.instance.success();
    }
  }

  Color get _borderColor {
    switch (widget.state) {
      case KidsOptionState.correct:
        return KidsTheme.correctGreen;
      case KidsOptionState.wrong:
        return KidsTheme.wrongRed;
      case KidsOptionState.selected:
        return widget.accent;
      case KidsOptionState.idle:
        return KidsTheme.optionBorder;
    }
  }

  Color get _tint {
    switch (widget.state) {
      case KidsOptionState.correct:
        return KidsTheme.correctGreen;
      case KidsOptionState.wrong:
        return KidsTheme.wrongRed;
      case KidsOptionState.selected:
        return widget.accent;
      case KidsOptionState.idle:
        return widget.accent;
    }
  }

  Widget? _badge() {
    switch (widget.state) {
      case KidsOptionState.correct:
        return _StatusBadge(
          icon: Icons.check_rounded,
          color: KidsTheme.correctGreen,
        );
      case KidsOptionState.wrong:
        return _StatusBadge(
          icon: Icons.close_rounded,
          color: KidsTheme.wrongRed,
        );
      case KidsOptionState.selected:
      case KidsOptionState.idle:
        return null;
    }
  }

  Widget _content() {
    if (widget.child != null) return widget.child!;

    final bool hasArt =
        (widget.imageAsset != null && widget.imageAsset!.isNotEmpty) ||
            widget.icon != null;

    if (!hasArt) {
      return Center(
        child: Text(
          widget.label ?? '',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: KidsTheme.label(
            fontSize: widget.fontSize,
            color: KidsTheme.inkDark,
          ),
        ),
      );
    }

    final Widget art = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double side = constraints.biggest.shortestSide;
        return _KidsArt(
          asset: widget.imageAsset,
          icon: widget.icon,
          size: side.isFinite && side > 0 ? side : 64,
          tint: _tint,
        );
      },
    );

    if (widget.label == null || widget.label!.isEmpty) {
      return Center(child: art);
    }

    return Column(
      children: <Widget>[
        Expanded(child: Center(child: art)),
        const SizedBox(height: 6),
        Text(
          widget.label!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: KidsTheme.label(
            fontSize: widget.fontSize * 0.6,
            color: KidsTheme.inkDark,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius =
        BorderRadius.circular(KidsTheme.radiusOption);
    final Color border = _borderColor;
    final bool highlighted = widget.state != KidsOptionState.idle;
    final Widget? badge = _badge();

    Widget tile = Container(
      decoration: BoxDecoration(
        gradient: highlighted
            ? KidsTheme.softFill(border, strength: 0.28)
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.white, Color(0xFFF3F9FF)],
              ),
        borderRadius: radius,
        border: Border.all(color: border, width: highlighted ? 5 : 4),
        boxShadow: KidsTheme.pillowShadow(
          highlighted ? border : const Color(0xFFC8DCEC),
          depth: 4,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          _Gloss(radius: radius),
          Padding(padding: widget.padding, child: _content()),
          if (badge != null) Positioned(top: -6, right: -6, child: badge),
        ],
      ),
    );

    if (widget.size != null) {
      tile = SizedBox(width: widget.size, height: widget.size, child: tile);
    }

    tile = KidsShake(trigger: _shakeTrigger, playSound: true, child: tile);

    return KidsSquish(
      onTap: widget.enabled ? widget.onTap : null,
      pressedScale: 0.93,
      child: tile,
    );
  }
}

/// Small circular check / cross stamp pinned to a quiz option corner.
class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _StatusBadge({Key? key, required this.icon, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: KidsTheme.softShadow(y: 2, blur: 6),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 20, color: Colors.white),
    );
  }
}
