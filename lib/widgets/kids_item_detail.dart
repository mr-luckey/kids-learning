import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// Shared letter/item detail page (speaker + prev/next) for all Sound screens.
class KidsItemDetail extends StatefulWidget {
  final String title;
  final List<Numbermodel> items;
  final int initialIndex;
  /// Optional second image (used by Numbers).
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
      await _tts.setPitch(1.2);
      await _tts.setVolume(1.0);
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
    KidsSound.instance.speak();
    try {
      await _tts.stop();
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

    return Scaffold(
      body: KidsSkyBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Row(
                  children: [
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
                        (c.maxWidth * 0.82).clamp(180.0, c.maxHeight * 0.72);
                    return Center(
                      child: KidsBounce(
                        child: SizedBox(
                          width: side,
                          height: side,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: KidsTheme.softFill(accent),
                                  borderRadius: BorderRadius.circular(36),
                                  border:
                                      Border.all(color: Colors.white, width: 5),
                                  boxShadow:
                                      KidsTheme.pillowShadow(accent, depth: 6),
                                ),
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        item.image!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    if (secondary != null &&
                                        secondary.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Image.asset(
                                          secondary,
                                          height: side * 0.28,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (badge.isNotEmpty)
                                Positioned(
                                  top: -6,
                                  right: -6,
                                  child: KidsPulse(
                                    child: Container(
                                      width: 52,
                                      height: 52,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient:
                                            KidsTheme.candyFill(KidsTheme.alphabet),
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
                  children: [
                    KidsCircleNav.previous(
                      enabled: _index > 0,
                      onTap: () => _go(-1),
                    ),
                    KidsSpeakerButton(
                      size: 84,
                      isPlaying: _speaking,
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
