import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';

/// ---------------------------------------------------------------------------
/// KidsBounce
/// ---------------------------------------------------------------------------
/// Continuous, gentle float + breathe. Nothing on a preschool screen should be
/// completely still — idle motion is what keeps a 3 year old looking at it.
class KidsBounce extends StatefulWidget {
  final Widget child;

  /// One full up-and-down cycle.
  final Duration duration;

  /// Start offset inside the cycle, so a grid of tiles does not bob in unison.
  final Duration delay;

  /// Vertical travel in logical pixels.
  final double offset;

  /// Extra scale at the top of the bounce (0.02 == 2%).
  final double scale;

  /// Small left/right tilt in radians. 0 disables rotation.
  final double tilt;

  final bool enabled;

  const KidsBounce({
    Key? key,
    required this.child,
    this.duration = KidsTheme.bounceDuration,
    this.delay = Duration.zero,
    this.offset = 6.0,
    this.scale = 0.02,
    this.tilt = 0.0,
    this.enabled = true,
  }) : super(key: key);

  @override
  _KidsBounceState createState() => _KidsBounceState();
}

class _KidsBounceState extends State<KidsBounce>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _wave;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _wave = CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine);
    if (widget.enabled) _start();
  }

  void _start() {
    final int cycleMs = widget.duration.inMilliseconds;
    final double phase =
        cycleMs == 0 ? 0.0 : (widget.delay.inMilliseconds % cycleMs) / cycleMs;
    // Seed the phase *before* repeating: `repeat` starts from the current
    // value, while the `value` setter would stop a running repeat.
    _controller.value = phase;
    _controller.repeat(reverse: true, min: 0.0, max: 1.0);
  }

  @override
  void didUpdateWidget(covariant KidsBounce oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _start();
      } else {
        _controller.stop();
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _wave,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double t = _wave.value; // 0 -> 1 -> 0
        return Transform.translate(
          offset: Offset(0, -widget.offset * t),
          child: Transform.rotate(
            angle: widget.tilt * (t - 0.5) * 2,
            child: Transform.scale(
              scale: 1.0 + widget.scale * t,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// KidsSquish
/// ---------------------------------------------------------------------------
/// Tap feedback: the child squashes down under the finger, then pops back with
/// an elastic overshoot. This is the single most important interaction in the
/// whole design language — every tappable thing should use it.
class KidsSquish extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Scale at full press. 0.90 == squashed to 90%.
  final double pressedScale;

  /// Plays the shared tap click before invoking [onTap].
  final bool playSound;

  /// Delay before [onTap] fires, letting the pop animation be seen.
  final Duration callbackDelay;

  final HitTestBehavior behavior;

  const KidsSquish({
    Key? key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.pressedScale = 0.90,
    this.playSound = true,
    this.callbackDelay = const Duration(milliseconds: 90),
    this.behavior = HitTestBehavior.opaque,
  }) : super(key: key);

  @override
  _KidsSquishState createState() => _KidsSquishState();
}

class _KidsSquishState extends State<KidsSquish>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: KidsTheme.squishDuration,
      reverseDuration: KidsTheme.popDuration,
    );
    _scale = Tween<double>(begin: 1.0, end: widget.pressedScale).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _interactive => widget.onTap != null || widget.onLongPress != null;

  void _press() {
    if (!_interactive) return;
    _controller.forward();
  }

  void _release() {
    if (!_interactive) return;
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.onTap == null) return;
    if (widget.playSound) KidsSound.instance.tap();
    final VoidCallback callback = widget.onTap!;
    if (widget.callbackDelay == Duration.zero) {
      callback();
      return;
    }
    Future<void>.delayed(widget.callbackDelay, () {
      if (mounted) callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (TapDownDetails _) => _press(),
      onTapUp: (TapUpDetails _) => _release(),
      onTapCancel: _release,
      onTap: _interactive ? _handleTap : null,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// KidsPulse
/// ---------------------------------------------------------------------------
/// Slow "look at me" heartbeat for primary calls to action (Next, Speaker).
/// Optionally draws an expanding halo ring behind the child.
class KidsPulse extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool enabled;

  /// Colour of the expanding halo. Null hides the halo.
  final Color? glowColor;

  /// Halo shape. Circles for round buttons, rounded rects for wide CTAs.
  final BorderRadius? glowRadius;

  const KidsPulse({
    Key? key,
    required this.child,
    this.duration = KidsTheme.pulseDuration,
    this.minScale = 1.0,
    this.maxScale = 1.06,
    this.enabled = true,
    this.glowColor,
    this.glowRadius,
  }) : super(key: key);

  @override
  _KidsPulseState createState() => _KidsPulseState();
}

class _KidsPulseState extends State<KidsPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _t = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (widget.enabled) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant KidsPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _t,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double t = _t.value;
        final double scale =
            widget.minScale + (widget.maxScale - widget.minScale) * t;
        final Widget scaled = Transform.scale(scale: scale, child: child);
        final Color? glow = widget.glowColor;
        if (glow == null) return scaled;
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: IgnorePointer(
                child: Transform.scale(
                  scale: 1.0 + 0.22 * t,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: glow.withOpacity(0.28 * (1.0 - t)),
                      shape: widget.glowRadius == null
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      borderRadius: widget.glowRadius,
                    ),
                  ),
                ),
              ),
            ),
            scaled,
          ],
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// KidsShake
/// ---------------------------------------------------------------------------
/// Soft "nope, try again" wiggle. Increment [trigger] to fire one shake — no
/// controller plumbing needed at the call site:
///
/// ```dart
/// KidsShake(trigger: _wrongCount, child: option)
/// ```
class KidsShake extends StatefulWidget {
  final Widget child;

  /// Every change to this value plays one shake.
  final int trigger;

  /// Horizontal travel of the wiggle, in logical pixels.
  final double amplitude;

  /// Number of left/right swings.
  final int shakes;

  final Duration duration;

  /// Plays the gentle "wrong" sound alongside the wiggle.
  final bool playSound;

  const KidsShake({
    Key? key,
    required this.child,
    required this.trigger,
    this.amplitude = 10.0,
    this.shakes = 3,
    this.duration = KidsTheme.shakeDuration,
    this.playSound = false,
  }) : super(key: key);

  @override
  _KidsShakeState createState() => _KidsShakeState();
}

class _KidsShakeState extends State<KidsShake>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didUpdateWidget(covariant KidsShake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) {
      if (widget.playSound) KidsSound.instance.softWrong();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double t = _controller.value;
        if (t == 0.0 || t == 1.0) return child!;
        // Damped sine: big first swing, fading out. Feels playful, not angry.
        final double damp = 1.0 - t;
        final double dx = math.sin(t * math.pi * 2 * widget.shakes) *
            widget.amplitude *
            damp;
        return Transform.translate(
          offset: Offset(dx, 0),
          child: Transform.rotate(angle: dx / 260.0, child: child),
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// KidsPopIn
/// ---------------------------------------------------------------------------
/// One-shot entrance used to stagger lists of tiles/pills so a screen "builds
/// itself" in front of the child instead of appearing all at once.
class KidsPopIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const KidsPopIn({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 520),
  }) : super(key: key);

  @override
  _KidsPopInState createState() => _KidsPopInState();
}

class _KidsPopInState extends State<KidsPopIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.72, end: 1.0).animate(_scale),
        child: widget.child,
      ),
    );
  }
}
