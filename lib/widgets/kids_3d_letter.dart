import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';

/// Glossy animated letter character for Alphabet lessons.
class Kids3DLetter extends StatefulWidget {
  final String letter;
  final double size;
  final bool animate;
  final Duration bounceDelay;

  const Kids3DLetter({
    Key? key,
    required this.letter,
    this.size = 160,
    this.animate = true,
    this.bounceDelay = Duration.zero,
  }) : super(key: key);

  static String assetFor(String letter) {
    final String t = letter.trim();
    final String ch = t.isEmpty ? 'A' : t[0].toUpperCase();
    return 'assets/ui/letter_$ch.png';
  }

  static bool isLetter(String? text) {
    if (text == null) return false;
    final String t = text.trim();
    return t.length == 1 && RegExp(r'^[A-Za-z]$').hasMatch(t);
  }

  @override
  State<Kids3DLetter> createState() => _Kids3DLetterState();
}

class _Kids3DLetterState extends State<Kids3DLetter>
    with TickerProviderStateMixin {
  late final AnimationController _blink;
  late final AnimationController _wiggle;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _wiggle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (widget.animate) {
      _wiggle.repeat(reverse: true);
      _blinkTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!mounted) return;
        _blink.forward().then((_) {
          if (mounted) {
            _blink.reverse();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _blink.dispose();
    _wiggle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String asset = Kids3DLetter.assetFor(widget.letter);
    final Widget art = Image.asset(
      asset,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => _fallback(),
    );

    if (!widget.animate) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: art,
      );
    }

    return KidsBounce(
      delay: widget.bounceDelay,
      offset: widget.size * 0.035,
      scale: 0.03,
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[_wiggle, _blink]),
        builder: (BuildContext context, Widget? child) {
          final double tilt = math.sin(_wiggle.value * math.pi) * 0.05;
          final double blink = _blink.value;
          return Transform.rotate(
            angle: tilt,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                child!,
                if (blink > 0.05)
                  Positioned(
                    top: widget.size * 0.40,
                    child: Opacity(
                      opacity: blink,
                      child: Container(
                        width: widget.size * 0.34,
                        height: widget.size * 0.045 * blink,
                        decoration: BoxDecoration(
                          color: KidsTheme.inkDark.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        child: art,
      ),
    );
  }

  Widget _fallback() {
    final String t = widget.letter.trim();
    final String ch = t.isEmpty ? '?' : t[0].toUpperCase();
    return Container(
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: KidsTheme.candyFill(KidsTheme.alphabet),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: KidsTheme.pillowShadow(KidsTheme.alphabet),
      ),
      child: Text(
        ch,
        style: TextStyle(
          fontFamily: KidsTheme.fontFamily,
          fontSize: widget.size * 0.55,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
