import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kids/homeScreen.dart';
import 'package:kids/services/ads_service.dart';
import 'package:kids/services/app_services.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/utils/banner_ad_widget.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// Letter artwork for the alphabet quiz.
List<Numbermodel> kidslist = KidsList1();

/// Alphabet round of the look-and-choose quiz: a letter is shown and the
/// child picks the word that starts with it.
class ABCQuiz extends StatelessWidget {
  const ABCQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'ABC Quiz',
      items: kidslist,
      questions: questions,
      accent: KidsTheme.alphabet,
    );
  }
}

// ===========================================================================
// Result screen
// ===========================================================================

/// Celebration screen shown at the end of every quiz in the app.
///
/// The positional `score` argument is kept because the other quiz screens
/// construct it as `ResultSrceen(score)`.
class ResultSrceen extends StatefulWidget {
  final int score;

  /// Number of questions in the quiz, when the caller knows it.
  final int? total;

  ResultSrceen(this.score, {Key? key, this.total}) : super(key: key);

  @override
  _ResultSrceenState createState() => _ResultSrceenState();
}

class _ResultSrceenState extends State<ResultSrceen> {
  int _burst = 0;
  bool _rewardBusy = false;
  bool _bonusClaimed = false;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    unawaited(
      AppServices.ads.preloadRewarded(placement: 'bonus_cheer'),
    );
    unawaited(
      AppServices.ads.preloadInterstitial(placement: 'after_quiz'),
    );
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!mounted) return;
      KidsSound.instance.success();
      setState(() => _burst++);
      Future<void>.delayed(const Duration(milliseconds: 520), () {
        if (!mounted) return;
        KidsSound.instance.sparkle();
        setState(() => _burst++);
      });
    });
  }

  /// 0..3 stars from the score, falling back to a fixed scale when the caller
  /// did not tell us how many questions there were.
  int get _stars {
    final int? total = widget.total;
    final double ratio = total == null || total <= 0
        ? (widget.score / 10).clamp(0.0, 1.0).toDouble()
        : widget.score / total;
    if (ratio >= 0.8) return 3;
    if (ratio >= 0.5) return 2;
    if (ratio > 0.0) return 1;
    return 0;
  }

  void _goPlayAgain() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Get.offAll(HomeScreen());
  }

  Future<void> _playAgain() async {
    if (_rewardBusy || _navigating) return;
    setState(() {
      _rewardBusy = true;
      _navigating = true;
    });

    final RewardedAdOutcome outcome =
        await AppServices.ads.showRewarded(placement: 'play_again');
    if (!mounted) return;

    if (outcome == RewardedAdOutcome.earned) {
      unawaited(
        AppServices.analytics.logRewardedAdCompleted(
          placement: 'play_again',
          source: 'quiz_result_play_again',
        ),
      );
      KidsSound.instance.sparkle();
    }

    setState(() {
      _rewardBusy = false;
      _navigating = false;
    });
    _goPlayAgain();
  }

  Future<void> _goHome() async {
    if (_navigating) return;
    setState(() => _navigating = true);
    await AppServices.ads.showInterstitial(placement: 'after_quiz');
    if (!mounted) return;
    Get.offAll(HomeScreen());
  }

  Future<void> _watchBonusCheer() async {
    if (_rewardBusy || _bonusClaimed || _navigating) return;
    setState(() => _rewardBusy = true);
    final RewardedAdOutcome outcome =
        await AppServices.ads.showRewarded(placement: 'bonus_cheer');
    if (!mounted) return;
    setState(() => _rewardBusy = false);

    if (outcome != RewardedAdOutcome.earned) {
      if (outcome == RewardedAdOutcome.unavailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bonus cheer is not ready yet')),
        );
      }
      return;
    }

    // Reward only after onUserEarnedReward — extra celebration, no fake currency.
    unawaited(
      AppServices.analytics.logRewardedAdCompleted(
        placement: 'bonus_cheer',
        source: 'quiz_result',
      ),
    );
    setState(() {
      _bonusClaimed = true;
      _burst++;
    });
    KidsSound.instance.sparkle();
    KidsSound.instance.success();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(placement: 'quiz'),
      body: KidsSkyBackground(
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    KidsBounce(
                      offset: 8,
                      scale: 0.03,
                      tilt: 0.02,
                      child: KidsBubbleTitle.colored(
                        'Yay!\nYou Did It!',
                        fillColor: KidsTheme.tileFunQuiz,
                        fontSize: 46,
                      ),
                    ),
                    const SizedBox(height: 22),
                    KidsPopIn(
                      delay: const Duration(milliseconds: 160),
                      child: _scoreBubble(),
                    ),
                    const SizedBox(height: 18),
                    KidsPopIn(
                      delay: const Duration(milliseconds: 320),
                      child: _starRow(),
                    ),
                    const SizedBox(height: 26),
                    if (!_bonusClaimed)
                      KidsPrimaryCta(
                        label: _rewardBusy
                            ? 'Loading…'
                            : 'Bonus Cheer!',
                        color: KidsTheme.tileFunQuiz,
                        leadingIcon: Icons.auto_awesome_rounded,
                        showArrow: false,
                        pulse: !_rewardBusy,
                        enabled: !_rewardBusy,
                        onTap: _watchBonusCheer,
                      ),
                    if (!_bonusClaimed) const SizedBox(height: 14),
                    if (_bonusClaimed)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Text(
                          'Bonus cheer unlocked!',
                          style: KidsTheme.label(fontSize: 18),
                        ),
                      ),
                    KidsPrimaryCta(
                      label: _rewardBusy ? 'Loading…' : 'Play Again',
                      color: KidsTheme.correctGreen,
                      leadingIcon: Icons.refresh_rounded,
                      showArrow: false,
                      enabled: !_rewardBusy && !_navigating,
                      onTap: _playAgain,
                    ),
                    const SizedBox(height: 14),
                    KidsPrimaryCta(
                      label: 'Home',
                      color: KidsTheme.rateBlue,
                      leadingIcon: Icons.home_rounded,
                      showArrow: false,
                      pulse: false,
                      enabled: !_navigating,
                      onTap: _goHome,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: ConfettiBurst(
                trigger: _burst,
                particleCount: 40,
                origin: const Alignment(0.0, -0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreBubble() {
    final int? total = widget.total;

    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: KidsTheme.softFill(KidsTheme.tileFunQuiz, strength: 0.26),
        border: Border.all(color: Colors.white, width: 7),
        boxShadow: KidsTheme.pillowShadow(KidsTheme.tileFunQuiz, depth: 6),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Your Score',
            style: KidsTheme.label(fontSize: 22),
          ),
          const SizedBox(height: 2),
          KidsBubbleTitle(
            total == null ? '${widget.score}' : '${widget.score}/$total',
            fontSize: total == null ? 76 : 56,
            fillColor: KidsTheme.bubbleFillBlue,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _starRow() {
    final int filled = _stars;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, (int i) {
        final bool on = i < filled;
        final Widget star = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            on ? Icons.star_rounded : Icons.star_border_rounded,
            size: on ? 62 : 52,
            color: on ? const Color(0xFFFFC93C) : Colors.white70,
            shadows: KidsTheme.softShadow(y: 3, blur: 6)
                .map((BoxShadow s) => Shadow(
                      color: s.color,
                      offset: s.offset,
                      blurRadius: s.blurRadius,
                    ))
                .toList(),
          ),
        );
        if (!on) return star;
        return KidsBounce(
          delay: Duration(milliseconds: 260 * i),
          offset: 5,
          scale: 0.06,
          child: star,
        );
      }),
    );
  }
}

// ===========================================================================
// ConfettiBurst
// ===========================================================================

const List<Color> _confettiColors = <Color>[
  Color(0xFFFF6BA8),
  Color(0xFFFFD93D),
  Color(0xFF4CD964),
  Color(0xFF4DA6FF),
  Color(0xFF9B6BFF),
  Color(0xFFFF8A3D),
  Color(0xFFFFFFFF),
];

/// One-shot confetti overlay painted with a single [CustomPaint].
///
/// Increment [trigger] to fire a burst; the widget paints nothing while it is
/// idle, so it is cheap to leave mounted on top of a screen.
class ConfettiBurst extends StatefulWidget {
  /// Every change to this value fires one burst.
  final int trigger;

  final int particleCount;
  final Duration duration;

  /// Burst origin inside the overlay, in [Alignment] coordinates.
  final Alignment origin;

  const ConfettiBurst({
    Key? key,
    required this.trigger,
    this.particleCount = 30,
    this.duration = const Duration(milliseconds: 1500),
    this.origin = const Alignment(0.0, -0.35),
  }) : super(key: key);

  @override
  _ConfettiBurstState createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final math.Random _random = math.Random();
  List<_Confetto> _pieces = const <_Confetto>[];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.trigger > 0) _fire();
  }

  @override
  void didUpdateWidget(covariant ConfettiBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.trigger != oldWidget.trigger) _fire();
  }

  void _fire() {
    _pieces = List<_Confetto>.generate(widget.particleCount, (int i) {
      // Fan the pieces upward and out to the sides.
      final double spread = math.pi * 1.35;
      final double angle =
          -math.pi / 2 - spread / 2 + spread * (i + _random.nextDouble()) /
              widget.particleCount;
      return _Confetto(
        angle: angle,
        speed: 0.35 + _random.nextDouble() * 0.55,
        size: 7.0 + _random.nextDouble() * 9.0,
        spin: (_random.nextDouble() - 0.5) * 12.0,
        color: _confettiColors[_random.nextInt(_confettiColors.length)],
        shape: _random.nextInt(3),
      );
    });
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? _) {
            final double t = _controller.value;
            if (t == 0.0 || t == 1.0 || _pieces.isEmpty) {
              return const SizedBox.expand();
            }
            return CustomPaint(
              size: Size.infinite,
              painter: _ConfettiPainter(
                progress: t,
                pieces: _pieces,
                origin: widget.origin,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Confetto {
  final double angle;
  final double speed;
  final double size;
  final double spin;
  final Color color;

  /// 0 = ribbon, 1 = dot, 2 = diamond.
  final int shape;

  const _Confetto({
    required this.angle,
    required this.speed,
    required this.size,
    required this.spin,
    required this.color,
    required this.shape,
  });
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_Confetto> pieces;
  final Alignment origin;

  const _ConfettiPainter({
    required this.progress,
    required this.pieces,
    required this.origin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double ox = (origin.x + 1) / 2 * size.width;
    final double oy = (origin.y + 1) / 2 * size.height;
    final double reach = size.shortestSide;

    // Launch fast, then coast — with gravity pulling everything back down.
    final double travel = 1.0 - math.pow(1.0 - progress, 2.0).toDouble();
    final double fade = progress < 0.7 ? 1.0 : (1.0 - progress) / 0.3;

    final Paint paint = Paint();

    for (final _Confetto piece in pieces) {
      final double distance = piece.speed * reach * travel;
      final double x = ox + math.cos(piece.angle) * distance;
      final double y = oy +
          math.sin(piece.angle) * distance +
          reach * 0.62 * progress * progress;

      paint.color = piece.color.withOpacity(fade.clamp(0.0, 1.0));

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(piece.spin * progress);

      switch (piece.shape) {
        case 1:
          canvas.drawCircle(Offset.zero, piece.size * 0.42, paint);
          break;
        case 2:
          final Path diamond = Path()
            ..moveTo(0, -piece.size * 0.62)
            ..lineTo(piece.size * 0.42, 0)
            ..lineTo(0, piece.size * 0.62)
            ..lineTo(-piece.size * 0.42, 0)
            ..close();
          canvas.drawPath(diamond, paint);
          break;
        default:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: piece.size,
                height: piece.size * 0.5,
              ),
              Radius.circular(piece.size * 0.18),
            ),
            paint,
          );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pieces != pieces ||
        oldDelegate.origin != origin;
  }
}
