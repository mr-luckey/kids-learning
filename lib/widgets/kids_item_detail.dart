import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_3d_letter.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// Shared letter/item detail page (speaker + prev/next) for all Sound screens.
class KidsItemDetail extends StatefulWidget {
  final String title;
  final List<Numbermodel> items;
  final int initialIndex;
  final String? Function(Numbermodel item)? secondaryImage;

  const KidsItemDetail({
    Key? key,
    required this.title,
    required this.items,
    required this.initialIndex,
    this.secondaryImage,
  }) : super(key: key);

  @override
  State<KidsItemDetail> createState() => _KidsItemDetailState();
}

class _KidsItemDetailState extends State<KidsItemDetail> {
  late int _index;
  late FlutterTts _tts;
  bool _speaking = false;

  int get _max => widget.items.length - 1;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, _max);
    _tts = FlutterTts();
    _configureTts();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  Future<void> _configureTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.15);
      // Max volume — effect SFX are intentionally quieter so speech wins.
      await _tts.setVolume(1.0);
      try {
        await _tts.awaitSpeakCompletion(true);
      } catch (_) {}
      _tts.setStartHandler(() {
        if (mounted) setState(() => _speaking = true);
      });
      _tts.setCompletionHandler(() {
        if (mounted) setState(() => _speaking = false);
      });
      _tts.setCancelHandler(() {
        if (mounted) setState(() => _speaking = false);
      });
      _tts.setErrorHandler((_) {
        if (mounted) setState(() => _speaking = false);
      });
    } catch (_) {}
  }

  Future<void> _speak() async {
    final String text = widget.items[_index].Text ?? '';
    if (text.isEmpty) return;
    // Quiet cue only — never let SFX overpower the letter voice.
    KidsSound.instance.speak();
    try {
      await _tts.stop();
      // Tiny beat so the soft cue finishes before loud speech.
      await Future<void>.delayed(const Duration(milliseconds: 80));
      await _tts.setVolume(1.0);
      await _tts.speak(text);
    } catch (_) {
      if (mounted) setState(() => _speaking = false);
    }
  }

  void _go(int delta) {
    final int next = (_index + delta).clamp(0, _max);
    if (next == _index) return;
    KidsSound.instance.whoosh();
    setState(() => _index = next);
    _speak();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Numbermodel item = widget.items[_index];
    final String badge = item.Text ?? '';
    final String? secondary =
        widget.secondaryImage != null ? widget.secondaryImage!(item) : null;
    final Color accent =
        KidsTheme.categoryPalette[_index % KidsTheme.categoryPalette.length];
    final bool isLetter = Kids3DLetter.isLetter(badge);

    return Scaffold(
      body: KidsSkyBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Row(
                  children: <Widget>[
                    KidsCircleNav.back(
                      onTap: () {
                        KidsSound.instance.whoosh();
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: KidsBubbleTitle(widget.title, fontSize: 34),
                    ),
                    const SizedBox(width: 56),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints c) {
                    final double side =
                        (c.maxWidth * 0.86).clamp(200.0, c.maxHeight * 0.78);
                    return Center(
                      child: KidsBounce(
                        offset: 8,
                        scale: 0.03,
                        child: SizedBox(
                          width: side,
                          height: side,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      Colors.white,
                                      Color.lerp(Colors.white, accent, 0.18)!,
                                      Color.lerp(Colors.white, accent, 0.32)!,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(36),
                                  border:
                                      Border.all(color: Colors.white, width: 5),
                                  boxShadow:
                                      KidsTheme.pillowShadow(accent, depth: 7),
                                ),
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: isLetter
                                          ? Kids3DLetter(
                                              letter: badge,
                                              size: side * 0.72,
                                            )
                                          : _NumberDigitsArt(
                                              primary: item.image,
                                              secondary: secondary,
                                              size: side * 0.72,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              if (badge.isNotEmpty)
                                Positioned(
                                  top: -8,
                                  right: -8,
                                  child: KidsPulse(
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: KidsTheme.candyFill(
                                            KidsTheme.alphabet),
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                        boxShadow: KidsTheme.pillowShadow(
                                            KidsTheme.alphabet,
                                            depth: 3),
                                      ),
                                      child: Text(
                                        badge.length > 3
                                            ? badge.substring(0, 3)
                                            : badge,
                                        style: const TextStyle(
                                          fontFamily: KidsTheme.fontFamily,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              // Wooden stump hint under letter (mockup vibe)
                              if (isLetter)
                                Positioned(
                                  bottom: 8,
                                  left: side * 0.22,
                                  right: side * 0.22,
                                  child: Container(
                                    height: 18,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: <Color>[
                                          Color(0xFFB57A45),
                                          Color(0xFF8B5A2B),
                                        ],
                                      ),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                          color: Color(0x33000000),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    KidsCircleNav.previous(
                      enabled: _index > 0,
                      onTap: () => _go(-1),
                    ),
                    KidsSpeakerButton(
                      size: 88,
                      isPlaying: _speaking,
                      pulse: true,
                      onTap: _speak,
                    ),
                    KidsCircleNav.next(
                      enabled: _index < _max,
                      pulse: _index < _max,
                      onTap: () => _go(1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders a number as one visual: single digit for 0–9, side-by-side for 10–99.
class _NumberDigitsArt extends StatelessWidget {
  final String? primary;
  final String? secondary;
  final double size;

  const _NumberDigitsArt({
    Key? key,
    required this.primary,
    required this.secondary,
    required this.size,
  }) : super(key: key);

  static const String _zeroAsset = 'assets/images/80.png';

  @override
  Widget build(BuildContext context) {
    final String? tens = primary;
    final String? ones = secondary;

    if (tens == null || tens.isEmpty) {
      return const SizedBox.shrink();
    }

    // 0–9 are stored as tens=0 + ones=digit — show only the ones digit.
    final bool singleDigit =
        tens == _zeroAsset && ones != null && ones.isNotEmpty;

    if (singleDigit || ones == null || ones.isEmpty) {
      return Image.asset(
        singleDigit ? ones : tens,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      );
    }

    // 10–99: both digits together on one row (e.g. 11).
    final double digitSize = size * 0.55;
    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            tens,
            width: digitSize,
            height: digitSize,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
          Image.asset(
            ones,
            width: digitSize,
            height: digitSize,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ],
      ),
    );
  }
}
