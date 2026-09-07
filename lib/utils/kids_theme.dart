import 'package:flutter/material.dart';

/// Central design tokens for the preschool ("Cocomelon style") redesign.
///
/// Everything here is `const` where possible so the widgets stay cheap to
/// rebuild. Colours, radii, shadows and text styles all live in this one file
/// so the whole app can be re-skinned from a single place.
class KidsTheme {
  KidsTheme._();

  static const String fontFamily = 'arlrdbd';

  // ---------------------------------------------------------------------
  // Sky + meadow
  // ---------------------------------------------------------------------
  static const Color skyTop = Color(0xFF7EC8F5);
  static const Color skyMid = Color(0xFFA8DFF0);
  static const Color skyLow = Color(0xFFC9ECF7);
  static const Color grass = Color(0xFF6BCB3C);
  static const Color grassDeep = Color(0xFF4CAF50);
  static const Color grassLight = Color(0xFF8BDD5A);
  static const Color cloud = Color(0xFFFFFFFF);

  /// Full screen gradient: blue sky fading down into the green meadow.
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      skyTop,
      skyMid,
      skyLow,
      grassLight,
      grass,
      grassDeep,
    ],
    stops: <double>[0.0, 0.28, 0.58, 0.74, 0.87, 1.0],
  );

  // ---------------------------------------------------------------------
  // Bubble titles
  // ---------------------------------------------------------------------
  /// Thick outline used around every bubble headline.
  static const Color bubbleOutline = Color(0xFF1A6FB5);
  static const Color bubbleFill = Color(0xFFFFFFFF);
  static const Color bubbleFillBlue = Color(0xFFCDEBFF);
  static const Color bubbleShadow = Color(0x40000000);

  // ---------------------------------------------------------------------
  // Category pill borders
  // ---------------------------------------------------------------------
  static const Color alphabet = Color(0xFFFF8A3D);
  static const Color number = Color(0xFFFF6BA8);
  static const Color color = Color(0xFF4CD964);
  static const Color shape = Color(0xFF9B6BFF);
  static const Color animal = Color(0xFF4DA6FF);
  static const Color bird = Color(0xFF2EC4B6);
  static const Color flower = Color(0xFFFF7EB3);
  static const Color fruits = Color(0xFFFFC93C);

  /// Ordered palette used when a screen needs "the next" category colour.
  static const List<Color> categoryPalette = <Color>[
    alphabet,
    number,
    color,
    shape,
    animal,
    bird,
    flower,
    fruits,
  ];

  static const Map<String, Color> _categoryColors = <String, Color>{
    'alphabet': alphabet,
    'alphabets': alphabet,
    'abc': alphabet,
    'letter': alphabet,
    'letters': alphabet,
    'number': number,
    'numbers': number,
    '123': number,
    'count': number,
    'counting': number,
    'color': color,
    'colors': color,
    'colour': color,
    'colours': color,
    'shape': shape,
    'shapes': shape,
    'animal': animal,
    'animals': animal,
    'bird': bird,
    'birds': bird,
    'flower': flower,
    'flowers': flower,
    'fruit': fruits,
    'fruits': fruits,
    'vegetable': color,
    'vegetables': color,
  };

  /// Looks up the mockup colour for a category name. Falls back to a stable
  /// palette entry (derived from the name) so unknown categories still look
  /// intentional instead of grey.
  static Color categoryColor(String name) {
    final String key = name.trim().toLowerCase();
    final Color? exact = _categoryColors[key];
    if (exact != null) return exact;
    for (final MapEntry<String, Color> entry in _categoryColors.entries) {
      if (key.contains(entry.key)) return entry.value;
    }
    if (key.isEmpty) return alphabet;
    return categoryPalette[key.codeUnits
            .fold<int>(0, (int a, int b) => a + b) %
        categoryPalette.length];
  }

  // ---------------------------------------------------------------------
  // Home tiles
  // ---------------------------------------------------------------------
  static const Color tileStartLearning = Color(0xFF7ED957);
  static const Color tileFunQuiz = Color(0xFFFF7BAC);
  static const Color tilePlay = tileFunQuiz;
  static const Color tileLookChoose = Color(0xFFFFD93D);
  static const Color tileListenGuess = Color(0xFFB794F6);

  // ---------------------------------------------------------------------
  // Controls
  // ---------------------------------------------------------------------
  static const Color nextOrange = Color(0xFFFF8C42);
  static const Color speakerYellow = Color(0xFFFFD54F);
  static const Color navOrange = Color(0xFFFF9F43);
  static const Color backBlue = Color(0xFF4DA6FF);
  static const Color rateBlue = Color(0xFF3B9EFF);

  static const Color correctGreen = Color(0xFF4CD964);
  static const Color wrongRed = Color(0xFFFF5C5C);
  static const Color optionSurface = Color(0xFFFFFFFF);
  static const Color optionBorder = Color(0xFFDCE9F5);
  static const Color inkDark = Color(0xFF15486E);

  // ---------------------------------------------------------------------
  // Radii
  // ---------------------------------------------------------------------
  static const double radiusPill = 30.0;
  static const double radiusPillSmall = 28.0;
  static const double radiusPillLarge = 32.0;
  static const double radiusTile = 28.0;
  static const double radiusOption = 20.0;

  static BorderRadius get pillRadius => BorderRadius.circular(radiusPill);
  static BorderRadius get tileRadius => BorderRadius.circular(radiusTile);
  static BorderRadius get optionRadius => BorderRadius.circular(radiusOption);

  // ---------------------------------------------------------------------
  // Colour helpers
  // ---------------------------------------------------------------------
  /// Darkens [source] by [amount] (0..1). Used for pressed states, text ink
  /// and the "under-lip" shadow that gives buttons their 3D pillow look.
  static Color darken(Color source, [double amount = 0.18]) {
    final HSLColor hsl = HSLColor.fromColor(source);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Lightens [source] by [amount] (0..1).
  static Color lighten(Color source, [double amount = 0.18]) {
    final HSLColor hsl = HSLColor.fromColor(source);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Boosts saturation so pastel inputs still read as "candy bright".
  static Color saturate(Color source, [double amount = 0.15]) {
    final HSLColor hsl = HSLColor.fromColor(source);
    return hsl
        .withSaturation((hsl.saturation + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Readable ink colour for text sitting on top of [background].
  static Color inkOn(Color background) {
    return background.computeLuminance() > 0.6
        ? darken(saturate(background, 0.2), 0.34)
        : Colors.white;
  }

  // ---------------------------------------------------------------------
  // Gradients + shadows
  // ---------------------------------------------------------------------
  /// Soft "white to light tint" fill used by category pills and quiz options.
  static LinearGradient softFill(Color tint, {double strength = 0.16}) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Colors.white,
        Color.alphaBlend(tint.withOpacity(strength * 0.5), Colors.white),
        Color.alphaBlend(tint.withOpacity(strength), Colors.white),
      ],
      stops: const <double>[0.0, 0.55, 1.0],
    );
  }

  /// Glossy candy fill used by solid buttons and home tiles.
  static LinearGradient candyFill(Color base) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        lighten(base, 0.14),
        base,
        darken(base, 0.09),
      ],
      stops: const <double>[0.0, 0.55, 1.0],
    );
  }

  /// Top highlight sheen layered over glossy surfaces.
  static const LinearGradient glossSheen = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0x59FFFFFF),
      Color(0x14FFFFFF),
      Color(0x00FFFFFF),
    ],
    stops: <double>[0.0, 0.45, 1.0],
  );

  /// Diagonal highlight for circular buttons.
  static const RadialGradient circleGloss = RadialGradient(
    center: Alignment(-0.35, -0.55),
    radius: 1.05,
    colors: <Color>[
      Color(0x8CFFFFFF),
      Color(0x1FFFFFFF),
      Color(0x00FFFFFF),
    ],
    stops: <double>[0.0, 0.45, 1.0],
  );

  /// Generic soft drop shadow.
  static List<BoxShadow> softShadow({double y = 6, double blur = 14}) {
    return <BoxShadow>[
      BoxShadow(
        color: Colors.black.withOpacity(0.14),
        offset: Offset(0, y),
        blurRadius: blur,
      ),
    ];
  }

  /// Pillow shadow: a coloured "lip" underneath plus a soft ambient shadow.
  /// This is what makes the buttons feel squeezable.
  static List<BoxShadow> pillowShadow(Color base, {double depth = 5}) {
    return <BoxShadow>[
      BoxShadow(
        color: darken(base, 0.22).withOpacity(0.85),
        offset: Offset(0, depth),
        blurRadius: 0,
      ),
      BoxShadow(
        color: base.withOpacity(0.38),
        offset: Offset(0, depth + 5),
        blurRadius: depth + 10,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.10),
        offset: Offset(0, depth + 2),
        blurRadius: depth + 8,
      ),
    ];
  }

  // ---------------------------------------------------------------------
  // Text styles
  // ---------------------------------------------------------------------
  /// Flat label used inside pills and tiles.
  static TextStyle label({
    double fontSize = 22,
    Color color = inkDark,
    FontWeight weight = FontWeight.w700,
    double letterSpacing = 0.2,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.15,
    );
  }

  /// Label with a soft dark shadow, for text sitting on a coloured surface.
  static TextStyle labelOnColor({
    double fontSize = 22,
    Color color = Colors.white,
    Color shadowColor = const Color(0x59000000),
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: 0.4,
      height: 1.15,
      shadows: <Shadow>[
        Shadow(color: shadowColor, offset: const Offset(0, 2), blurRadius: 4),
      ],
    );
  }

  /// Stroke pass of a bubble headline. Rendered *behind* [bubbleFillStyle]
  /// with an identical layout so the two line up exactly.
  ///
  /// See `KidsBubbleTitle` which stacks these for you.
  static TextStyle bubbleStrokeStyle({
    double fontSize = 40,
    required Color strokeColor,
    required double strokeWidth,
    List<Shadow>? shadows,
    double letterSpacing = 1.0,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: letterSpacing,
      height: 1.18,
      shadows: shadows,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = strokeColor,
    );
  }

  /// Fill pass of a bubble headline.
  static TextStyle bubbleFillStyle({
    double fontSize = 40,
    Color fillColor = bubbleFill,
    double letterSpacing = 1.0,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: letterSpacing,
      height: 1.18,
      color: fillColor,
    );
  }

  /// Single-widget approximation of the bubble title (cheaper than the
  /// stacked version) for places where an outline-ish look is enough.
  static TextStyle bubbleTitle({
    double fontSize = 40,
    Color fillColor = bubbleFill,
    Color outlineColor = bubbleOutline,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
      height: 1.18,
      color: fillColor,
      shadows: <Shadow>[
        Shadow(color: outlineColor, offset: const Offset(2, 0), blurRadius: 1),
        Shadow(color: outlineColor, offset: const Offset(-2, 0), blurRadius: 1),
        Shadow(color: outlineColor, offset: const Offset(0, 2), blurRadius: 1),
        Shadow(color: outlineColor, offset: const Offset(0, -2), blurRadius: 1),
        const Shadow(
          color: bubbleShadow,
          offset: Offset(0, 4),
          blurRadius: 6,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Motion timings (shared so the whole app breathes at the same tempo)
  // ---------------------------------------------------------------------
  static const Duration bounceDuration = Duration(milliseconds: 2200);
  static const Duration pulseDuration = Duration(milliseconds: 1100);
  static const Duration squishDuration = Duration(milliseconds: 110);
  static const Duration popDuration = Duration(milliseconds: 380);
  static const Duration shakeDuration = Duration(milliseconds: 480);
}
