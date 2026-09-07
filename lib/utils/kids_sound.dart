import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Tiny, crash-proof sound-effect helper for the kids UI.
///
/// Design notes:
///  * Uses a small round-robin pool of [AudioPlayer]s so rapid taps overlap
///    instead of cutting each other off (kids tap *fast*).
///  * Every public method is fire-and-forget and swallows all errors. A
///    missing asset or a busy audio session must never break a lesson.
///  * [enabled] lets settings/mute toggles silence everything instantly.
class KidsSound {
  KidsSound._internal();

  static final KidsSound _instance = KidsSound._internal();

  factory KidsSound() => _instance;

  /// Convenience accessor: `KidsSound.instance.tap()`.
  static KidsSound get instance => _instance;

  // Asset paths are relative to `assets/` — audioplayers prefixes that for us.
  static const String _tap = 'sounds/tap.wav';
  static const String _success = 'sounds/success.wav';
  static const String _whoosh = 'sounds/whoosh.wav';
  static const String _softWrong = 'sounds/soft_wrong.wav';
  static const String _sparkle = 'sounds/sparkle.wav';
  static const String _speak = 'sounds/speak.wav';

  static const int _poolSize = 4;

  final List<AudioPlayer> _pool = <AudioPlayer>[];
  int _cursor = 0;
  bool _initialised = false;
  bool _broken = false;

  bool _enabled = true;
  /// Keep effect volume low so TTS / letter speech stays clearly louder.
  double _volume = 0.28;

  /// Whether sound effects are currently audible.
  bool get enabled => _enabled;

  set enabled(bool value) {
    _enabled = value;
    if (!value) {
      stopAll();
    }
  }

  /// Master volume in the 0..1 range.
  double get volume => _volume;

  set volume(double value) {
    _volume = value.clamp(0.0, 1.0).toDouble();
  }

  void mute() => enabled = false;

  void unmute() => enabled = true;

  bool toggleMute() {
    enabled = !_enabled;
    return _enabled;
  }

  void _ensurePool() {
    if (_initialised || _broken) return;
    _initialised = true;
    try {
      for (int i = 0; i < _poolSize; i++) {
        final AudioPlayer player = AudioPlayer();
        // Release mode `stop` keeps the native resource warm between taps.
        player.setReleaseMode(ReleaseMode.stop).catchError((Object _) {});
        _pool.add(player);
      }
    } catch (e) {
      _broken = true;
      _debug('pool creation failed: $e');
    }
  }

  Future<void> _play(String asset) async {
    if (!_enabled || _broken) return;
    _ensurePool();
    if (_pool.isEmpty) return;

    final AudioPlayer player = _pool[_cursor];
    _cursor = (_cursor + 1) % _pool.length;

    try {
      await player.stop();
    } catch (_) {
      // Player may not have been started yet — nothing to stop.
    }

    try {
      await player.play(AssetSource(asset), volume: _volume);
    } catch (e) {
      _debug('play failed for $asset: $e');
    }
  }

  /// Light click for any button press.
  void tap() {
    _fire(_play(_tap));
  }

  /// Happy chime for a correct answer / completed lesson.
  void success() {
    _fire(_play(_success));
  }

  /// Swipe / page-transition whoosh.
  void whoosh() {
    _fire(_play(_whoosh));
  }

  /// Gentle "try again" — deliberately not harsh for preschoolers.
  void softWrong() {
    _fire(_play(_softWrong));
  }

  /// Twinkle used for stars, rewards and celebration confetti.
  void sparkle() {
    _fire(_play(_sparkle));
  }

  /// Tiny cue before TTS — kept very quiet so letter speech dominates.
  void speak() {
    _fire(_playAt(_speak, 0.12));
  }

  Future<void> _playAt(String asset, double volume) async {
    if (!_enabled || _broken) return;
    _ensurePool();
    if (_pool.isEmpty) return;
    final AudioPlayer player = _pool[_cursor];
    _cursor = (_cursor + 1) % _pool.length;
    try {
      await player.stop();
    } catch (_) {}
    try {
      await player.play(
        AssetSource(asset),
        volume: (volume * _volume / 0.28).clamp(0.0, 1.0),
      );
    } catch (e) {
      _debug('play failed for $asset: $e');
    }
  }

  /// Plays an arbitrary asset under `assets/` (e.g. `sounds/letters/a.wav`).
  void playAsset(String assetPath) {
    _fire(_play(assetPath));
  }

  /// Stops every pooled player. Safe to call at any time.
  void stopAll() {
    for (final AudioPlayer player in _pool) {
      try {
        player.stop().catchError((Object _) {});
      } catch (_) {}
    }
  }

  /// Warms the native players up so the very first tap is not delayed.
  /// Call once from `main()` if you want zero-latency first feedback.
  Future<void> preload() async {
    if (_broken) return;
    _ensurePool();
    for (final AudioPlayer player in _pool) {
      try {
        await player.setSource(AssetSource(_tap));
      } catch (e) {
        _debug('preload failed: $e');
        return;
      }
    }
  }

  /// Releases native resources. Only needed if the app tears the audio
  /// stack down (most apps never call this).
  Future<void> dispose() async {
    for (final AudioPlayer player in _pool) {
      try {
        await player.dispose();
      } catch (_) {}
    }
    _pool.clear();
    _initialised = false;
    _cursor = 0;
  }

  /// Fire-and-forget: never let a rejected audio future reach the zone.
  void _fire(Future<void> future) {
    future.catchError((Object _) {});
  }

  void _debug(String message) {
    if (kDebugMode) {
      debugPrint('[KidsSound] $message');
    }
  }
}
