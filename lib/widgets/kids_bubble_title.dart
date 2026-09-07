import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';

/// Chunky "sticker" headline from the mockup: a fat rounded font with a thick
/// blue outline, an inner white rim and a soft drop shadow.
///
/// It is drawn as four perfectly-aligned passes of the same [Text]:
///   1. drop shadow (stroke, offset down, blurred)
///   2. outer outline stroke  ([outlineColor], [strokeWidth])
///   3. inner rim stroke      ([rimColor],     [rimWidth])   — optional
///   4. solid fill            ([fillColor])
///
/// ```dart
/// KidsBubbleTitle('Let\'s Start\nLearning', fontSize: 44)
/// KidsBubbleTitle('Fun Quiz', fillColor: KidsTheme.bubbleFillBlue)
/// ```
class KidsBubbleTitle extends StatelessWidget {
  final String text;
  final double fontSize;

  /// Colour of the letters themselves.
  final Color fillColor;

  /// Thick outer outline.
  final Color outlineColor;

  /// Width of the outer outline in logical pixels.
  final double strokeWidth;

  /// Optional bright rim drawn between the outline and the fill. Set to null
  /// for a single-outline look.
  final Color? rimColor;

  /// Width of the inner rim. Must be smaller than [strokeWidth].
  final double? rimWidth;

  final Color shadowColor;
  final Offset shadowOffset;
  final double shadowBlur;

  final TextAlign textAlign;
  final int? maxLines;
  final double letterSpacing;
  final double height;
  final TextOverflow overflow;

  const KidsBubbleTitle(
    this.text, {
    Key? key,
    this.fontSize = 40,
    this.fillColor = KidsTheme.bubbleFill,
    this.outlineColor = KidsTheme.bubbleOutline,
    double? strokeWidth,
    this.rimColor,
    this.rimWidth,
    this.shadowColor = KidsTheme.bubbleShadow,
    this.shadowOffset = const Offset(0, 4),
    this.shadowBlur = 6,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.letterSpacing = 1.0,
    this.height = 1.18,
    this.overflow = TextOverflow.visible,
  })  : strokeWidth = strokeWidth ?? fontSize * 0.18,
        super(key: key);

  /// Coloured-fill variant with a white rim — used for category headings.
  const KidsBubbleTitle.colored(
    this.text, {
    Key? key,
    required this.fillColor,
    this.fontSize = 40,
    this.outlineColor = KidsTheme.bubbleOutline,
    double? strokeWidth,
    this.shadowColor = KidsTheme.bubbleShadow,
    this.shadowOffset = const Offset(0, 4),
    this.shadowBlur = 6,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.letterSpacing = 1.0,
    this.height = 1.18,
    this.overflow = TextOverflow.visible,
  })  : strokeWidth = strokeWidth ?? fontSize * 0.20,
        rimColor = Colors.white,
        rimWidth = null,
        super(key: key);

  TextStyle _base() {
    return TextStyle(
      fontFamily: KidsTheme.fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  Widget _pass(TextStyle style) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
    );
  }

  Paint _stroke(Color color, double width) {
    return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = color;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle base = _base();
    final double innerWidth = rimWidth ?? strokeWidth * 0.46;

    final List<Widget> layers = <Widget>[
      // 1. Drop shadow — a blurred copy of the outline, nudged downward.
      _pass(base.copyWith(
        foreground: _stroke(shadowColor, strokeWidth),
        shadows: <Shadow>[
          Shadow(
            color: shadowColor,
            offset: shadowOffset,
            blurRadius: shadowBlur,
          ),
        ],
      )),
      // 2. Outer outline.
      _pass(base.copyWith(foreground: _stroke(outlineColor, strokeWidth))),
    ];

    // 3. Inner rim.
    if (rimColor != null) {
      layers.add(_pass(base.copyWith(foreground: _stroke(rimColor!, innerWidth))));
    }

    // 4. Fill.
    layers.add(_pass(base.copyWith(color: fillColor)));

    // `Clip.none` keeps the outer stroke from being shaved off at the edges.
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: layers,
    );
  }
}

/// A [KidsBubbleTitle] sitting on a translucent white pill — the label style
/// used underneath the home tiles and above quiz questions.
class KidsBubbleBanner extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color fillColor;
  final Color outlineColor;

  /// Pill background. Defaults to frosted white.
  final Color background;

  final EdgeInsetsGeometry padding;
  final int? maxLines;

  const KidsBubbleBanner(
    this.text, {
    Key? key,
    this.fontSize = 26,
    this.fillColor = KidsTheme.bubbleFill,
    this.outlineColor = KidsTheme.bubbleOutline,
    this.background = const Color(0x4DFFFFFF),
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(KidsTheme.radiusPill),
        border: Border.all(color: Colors.white.withOpacity(0.55), width: 2),
        boxShadow: KidsTheme.softShadow(y: 4, blur: 10),
      ),
      child: KidsBubbleTitle(
        text,
        fontSize: fontSize,
        fillColor: fillColor,
        outlineColor: outlineColor,
        maxLines: maxLines,
        overflow: maxLines == null ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }
}
