import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';

/// Full-screen animated sky + meadow used behind every kids screen.
///
/// Layers, back to front:
///   1. Blue -> green [KidsTheme.skyGradient].
///   2. A warm sun glow in the top corner.
///   3. Slowly drifting soft white clouds (looping, seamless).
///   4. Rolling grass hills with blades and little white flowers.
///   5. Optional twinkling sparkles floating through the sky.
///   6. The [child].
///
/// All painters are seeded from a fixed [seed], so the scenery is identical on
/// every rebuild and hot reload — only the motion changes.
class KidsSkyBackground extends StatefulWidget {
  final Widget child;

  /// Where the meadow starts, as a fraction of the screen height.
  final double horizon;

  /// Seconds for a cloud to cross the whole screen.
  final double cloudDriftSeconds;

  final int cloudCount;

  final bool showClouds;
  final bool showMeadow;
  final bool showSparkles;
  final bool showSun;

  /// Dims the whole scene slightly, useful behind busy content sheets.
  final double dim;

  final int seed;

  const KidsSkyBackground({
    Key? key,
    required this.child,
    this.horizon = 0.74,
    this.cloudDriftSeconds = 60,
    this.cloudCount = 5,
    this.showClouds = true,
    this.showMeadow = true,
    this.showSparkles = true,
    this.showSun = true,
    this.dim = 0.0,
    this.seed = 7,
  }) : super(key: key);

  @override
  _KidsSkyBackgroundState createState() => _KidsSkyBackgroundState();
}

class _KidsSkyBackgroundState extends State<KidsSkyBackground>
    with TickerProviderStateMixin {
  late final AnimationController _cloudController;
  late final AnimationController _sparkleController;

  late List<_Cloud> _clouds;
  late List<_Sparkle> _sparkles;
  late List<_Flower> _flowers;

  @override
  void initState() {
    super.initState();

    _cloudController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.cloudDriftSeconds * 1000).round()),
    );
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );

    _buildScenery();

    if (widget.showClouds) _cloudController.repeat();
    if (widget.showSparkles) _sparkleController.repeat();
  }

  void _buildScenery() {
    final math.Random random = math.Random(widget.seed);

    _clouds = List<_Cloud>.generate(widget.cloudCount, (int i) {
      return _Cloud(
        // Spread the clouds evenly, then jitter so the loop never looks gridded.
        startX: (i / widget.cloudCount) + random.nextDouble() * 0.12,
        y: 0.05 + random.nextDouble() * 0.34,
        scale: 0.62 + random.nextDouble() * 0.75,
        speed: 0.65 + random.nextDouble() * 0.6,
        opacity: 0.68 + random.nextDouble() * 0.3,
        bobPhase: random.nextDouble(),
      );
    });

    _sparkles = List<_Sparkle>.generate(14, (int _) {
      return _Sparkle(
        x: random.nextDouble(),
        y: 0.04 + random.nextDouble() * 0.6,
        size: 2.5 + random.nextDouble() * 4.5,
        phase: random.nextDouble(),
        speed: 0.6 + random.nextDouble() * 1.1,
      );
    });

    _flowers = List<_Flower>.generate(22, (int _) {
      return _Flower(
        x: random.nextDouble(),
        // Distributed through the meadow band, denser toward the bottom.
        depth: math.pow(random.nextDouble(), 0.7).toDouble(),
        size: 3.0 + random.nextDouble() * 4.0,
        yellowCenter: random.nextDouble() > 0.35,
      );
    });
  }

  @override
  void didUpdateWidget(covariant KidsSkyBackground oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.seed != oldWidget.seed ||
        widget.cloudCount != oldWidget.cloudCount) {
      _buildScenery();
    }
    if (widget.cloudDriftSeconds != oldWidget.cloudDriftSeconds) {
      _cloudController.duration =
          Duration(milliseconds: (widget.cloudDriftSeconds * 1000).round());
      if (widget.showClouds) _cloudController.repeat();
    }
    _syncController(_cloudController, widget.showClouds);
    _syncController(_sparkleController, widget.showSparkles);
  }

  void _syncController(AnimationController controller, bool shouldRun) {
    if (shouldRun && !controller.isAnimating) {
      controller.repeat();
    } else if (!shouldRun && controller.isAnimating) {
      controller.stop();
    }
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: KidsTheme.skyGradient),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (widget.showSun)
            const IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(painter: _SunPainter()),
              ),
            ),
          if (widget.showMeadow)
            IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _MeadowPainter(
                    horizon: widget.horizon,
                    flowers: _flowers,
                  ),
                ),
              ),
            ),
          if (widget.showClouds)
            IgnorePointer(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _cloudController,
                  builder: (BuildContext context, Widget? _) {
                    return CustomPaint(
                      painter: _CloudPainter(
                        progress: _cloudController.value,
                        clouds: _clouds,
                        horizon: widget.horizon,
                      ),
                    );
                  },
                ),
              ),
            ),
          if (widget.showSparkles)
            IgnorePointer(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _sparkleController,
                  builder: (BuildContext context, Widget? _) {
                    return CustomPaint(
                      painter: _SparklePainter(
                        progress: _sparkleController.value,
                        sparkles: _sparkles,
                      ),
                    );
                  },
                ),
              ),
            ),
          if (widget.dim > 0)
            IgnorePointer(
              child: ColoredBox(
                color: Colors.black.withOpacity(widget.dim.clamp(0.0, 1.0)),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scenery models
// ---------------------------------------------------------------------------

class _Cloud {
  final double startX;
  final double y;
  final double scale;
  final double speed;
  final double opacity;
  final double bobPhase;

  const _Cloud({
    required this.startX,
    required this.y,
    required this.scale,
    required this.speed,
    required this.opacity,
    required this.bobPhase,
  });
}

class _Sparkle {
  final double x;
  final double y;
  final double size;
  final double phase;
  final double speed;

  const _Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
    required this.speed,
  });
}

class _Flower {
  final double x;
  final double depth;
  final double size;
  final bool yellowCenter;

  const _Flower({
    required this.x,
    required this.depth,
    required this.size,
    required this.yellowCenter,
  });
}

// ---------------------------------------------------------------------------
// Painters
// ---------------------------------------------------------------------------

/// Warm sun glow tucked into the top-right corner.
class _SunPainter extends CustomPainter {
  const _SunPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.86, size.height * 0.06);
    final double radius = size.shortestSide * 0.34;

    final Paint glow = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          const Color(0xFFFFF6C2).withOpacity(0.85),
          const Color(0xFFFFE79A).withOpacity(0.32),
          const Color(0x00FFE79A),
        ],
        stops: const <double>[0.0, 0.42, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glow);

    final Paint core = Paint()..color = const Color(0xFFFFF3B0).withOpacity(0.9);
    canvas.drawCircle(center, radius * 0.28, core);
  }

  @override
  bool shouldRepaint(covariant _SunPainter oldDelegate) => false;
}

/// Rolling hills, grass blades and little white meadow flowers.
class _MeadowPainter extends CustomPainter {
  final double horizon;
  final List<_Flower> flowers;

  const _MeadowPainter({required this.horizon, required this.flowers});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double baseY = h * horizon;

    // --- Far hill (lighter, sits just under the sky) -----------------------
    final Path farHill = Path()..moveTo(0, baseY + 10);
    farHill.quadraticBezierTo(w * 0.18, baseY - 34, w * 0.42, baseY + 4);
    farHill.quadraticBezierTo(w * 0.68, baseY + 42, w * 0.84, baseY + 2);
    farHill.quadraticBezierTo(w * 0.94, baseY - 22, w, baseY + 14);
    farHill.lineTo(w, h);
    farHill.lineTo(0, h);
    farHill.close();
    canvas.drawPath(
      farHill,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFF9BE36B), KidsTheme.grass],
        ).createShader(Rect.fromLTWH(0, baseY - 40, w, h - baseY + 40)),
    );

    // --- Near hill (deeper green, overlaps the far hill) -------------------
    final double nearY = baseY + (h - baseY) * 0.34;
    final Path nearHill = Path()..moveTo(0, nearY + 18);
    nearHill.quadraticBezierTo(w * 0.26, nearY - 30, w * 0.55, nearY + 10);
    nearHill.quadraticBezierTo(w * 0.82, nearY + 44, w, nearY - 6);
    nearHill.lineTo(w, h);
    nearHill.lineTo(0, h);
    nearHill.close();
    canvas.drawPath(
      nearHill,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[KidsTheme.grass, KidsTheme.grassDeep],
        ).createShader(Rect.fromLTWH(0, nearY - 40, w, h - nearY + 40)),
    );

    // Soft highlight along the near crest only (not the closing screen edges),
    // so the hill reads as rounded instead of outlined.
    final Path nearCrest = Path()..moveTo(0, nearY + 18);
    nearCrest.quadraticBezierTo(w * 0.26, nearY - 30, w * 0.55, nearY + 10);
    nearCrest.quadraticBezierTo(w * 0.82, nearY + 44, w, nearY - 6);
    canvas.drawPath(
      nearCrest,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = const Color(0xFFB6F08A).withOpacity(0.55),
    );

    _paintBlades(canvas, size, baseY);
    _paintFlowers(canvas, size, baseY);
  }

  /// Short grass tufts poking up over the far crest. Deliberately low
  /// contrast — they should suggest texture, never compete with the UI.
  void _paintBlades(Canvas canvas, Size size, double baseY) {
    final Paint blade = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF7FD64A).withOpacity(0.55);

    const int count = 46;
    final double step = size.width / count;
    for (int i = 0; i <= count; i++) {
      final double x = i * step + math.sin(i * 5.13) * step * 0.35;
      // Deterministic pseudo-random height from the index.
      final double wobble = math.sin(i * 2.399) * 0.5 + 0.5;
      final double height = 5 + wobble * 12;
      final double lean = (i.isEven ? 1.0 : -1.0) * (3 + wobble * 3);
      final Path path = Path()
        ..moveTo(x, baseY + 12)
        ..quadraticBezierTo(
          x + lean * 0.5,
          baseY + 12 - height * 0.55,
          x + lean,
          baseY + 12 - height,
        );
      canvas.drawPath(path, blade);
    }
  }

  void _paintFlowers(Canvas canvas, Size size, double baseY) {
    final double meadowHeight = size.height - baseY;
    if (meadowHeight <= 0) return;

    final Paint petal = Paint()..color = Colors.white.withOpacity(0.92);
    final Paint centerYellow = Paint()..color = const Color(0xFFFFE066);
    final Paint centerPink = Paint()..color = const Color(0xFFFFB3D1);

    for (final _Flower flower in flowers) {
      final double cx = flower.x * size.width;
      final double cy = baseY + 12 + flower.depth * (meadowHeight - 16);
      // Perspective: flowers nearer the bottom of the screen are bigger.
      final double r = flower.size * (0.65 + flower.depth * 0.75);

      for (int p = 0; p < 5; p++) {
        final double angle = (p / 5) * math.pi * 2 - math.pi / 2;
        canvas.drawCircle(
          Offset(cx + math.cos(angle) * r, cy + math.sin(angle) * r),
          r * 0.72,
          petal,
        );
      }
      canvas.drawCircle(
        Offset(cx, cy),
        r * 0.62,
        flower.yellowCenter ? centerYellow : centerPink,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MeadowPainter oldDelegate) {
    return oldDelegate.horizon != horizon || oldDelegate.flowers != flowers;
  }
}

/// Puffy clouds that drift right and wrap around seamlessly.
class _CloudPainter extends CustomPainter {
  final double progress;
  final List<_Cloud> clouds;
  final double horizon;

  const _CloudPainter({
    required this.progress,
    required this.clouds,
    required this.horizon,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double skyHeight = size.height * horizon;

    for (final _Cloud cloud in clouds) {
      // Travel across [-0.25, 1.25] so clouds enter and exit off-screen.
      final double raw = (cloud.startX + progress * cloud.speed) % 1.5;
      final double x = (raw - 0.25) * size.width;
      final double bob =
          math.sin((progress * cloud.speed + cloud.bobPhase) * math.pi * 2) * 5;
      final double y = cloud.y * skyHeight + bob;

      _paintCloud(canvas, Offset(x, y), cloud.scale, cloud.opacity);
    }
  }

  void _paintCloud(Canvas canvas, Offset origin, double scale, double opacity) {
    final double unit = 26.0 * scale;

    // Puff layout: [dx, dy, radius] in "unit" space.
    const List<List<double>> puffs = <List<double>>[
      <double>[0.0, 0.35, 1.00],
      <double>[1.05, 0.00, 1.30],
      <double>[2.25, 0.28, 1.05],
      <double>[3.20, 0.55, 0.80],
      <double>[1.60, 0.75, 1.10],
    ];

    final Paint body = Paint()..color = Colors.white.withOpacity(opacity);
    final Paint shade = Paint()
      ..color = const Color(0xFFDDF1FB).withOpacity(opacity * 0.75);
    final Paint sheen = Paint()..color = Colors.white.withOpacity(opacity);

    // Soft under-shadow first, offset down a touch for volume.
    for (final List<double> p in puffs) {
      canvas.drawCircle(
        origin + Offset(p[0] * unit, p[1] * unit + unit * 0.30),
        p[2] * unit,
        shade,
      );
    }
    for (final List<double> p in puffs) {
      canvas.drawCircle(
        origin + Offset(p[0] * unit, p[1] * unit),
        p[2] * unit,
        body,
      );
    }
    // Bright top highlight for the glossy 3D feel.
    canvas.drawCircle(
      origin + Offset(1.05 * unit, -0.22 * unit),
      0.95 * unit,
      sheen,
    );

    // Flat-ish base so the cloud does not read as a pile of bubbles.
    final Rect base = Rect.fromLTWH(
      origin.dx - unit * 0.9,
      origin.dy + unit * 0.55,
      unit * 4.6,
      unit * 1.0,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(base, Radius.circular(unit * 0.5)),
      body,
    );
  }

  @override
  bool shouldRepaint(covariant _CloudPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.clouds != clouds ||
        oldDelegate.horizon != horizon;
  }
}

/// Twinkling four-point sparkles drifting slowly upward.
class _SparklePainter extends CustomPainter {
  final double progress;
  final List<_Sparkle> sparkles;

  const _SparklePainter({required this.progress, required this.sparkles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final _Sparkle sparkle in sparkles) {
      final double t = (progress * sparkle.speed + sparkle.phase) % 1.0;
      // Fade in and out once per loop.
      final double alpha = math.sin(t * math.pi).clamp(0.0, 1.0) * 0.75;
      if (alpha <= 0.02) continue;

      final double drift = (1.0 - t) * 26.0;
      final Offset center =
          Offset(sparkle.x * size.width, sparkle.y * size.height + drift);
      final double r = sparkle.size * (0.6 + 0.4 * math.sin(t * math.pi));

      final Paint paint = Paint()..color = Colors.white.withOpacity(alpha);
      canvas.drawCircle(center, r * 0.42, paint);

      // Four-point star: two tapered strokes.
      final Paint ray = Paint()
        ..color = Colors.white.withOpacity(alpha * 0.85)
        ..strokeWidth = math.max(1.0, r * 0.32)
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        center.translate(0, -r * 1.8),
        center.translate(0, r * 1.8),
        ray,
      );
      canvas.drawLine(
        center.translate(-r * 1.8, 0),
        center.translate(r * 1.8, 0),
        ray,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.sparkles != sparkles;
  }
}
