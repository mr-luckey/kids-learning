import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/Quiz/ABCQuize.dart';
import 'package:kids/services/app_services.dart';
import 'package:kids/utils/ad_helper.dart';
import 'package:kids/utils/banner_ad_widget.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_3d_letter.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// Shared category quiz screen, in two flavours.
///
/// *Look and choose* (the default) shows the artwork for a page and the child
/// picks the matching word. *Listen and guess* ([listenMode]) hides the
/// artwork behind a speaker button, speaks the word aloud and the child picks
/// the matching picture.
///
/// Every category quiz (numbers, colours, animals, …) is the same game with a
/// different artwork list and question bank, so they all render through this
/// one widget and only differ in [title], [items], [questions] and [accent].
///
/// The artwork list and the question bank are two independent lists in
/// `model.dart` and are not always the same length, so the quiz runs for
/// `min(items.length, questions.length)` pages.
class KidsQuizScreen extends StatefulWidget {
  /// Headline shown in the bubble title, e.g. `'Animal Quiz'`.
  final String title;

  /// Artwork shown above the options, one entry per question.
  final List<Numbermodel> items;

  /// Question bank; each answer map holds one `true` entry.
  final List<QuestionModel> questions;

  /// Category colour used for the title, the artwork card and the options.
  final Color accent;

  /// Turns the quiz into a listen-and-guess round: the artwork card becomes a
  /// speaker the child can tap, the word for each page is spoken on arrival,
  /// and answers that are asset paths render as pictures instead of text.
  final bool listenMode;

  const KidsQuizScreen({
    Key? key,
    required this.title,
    required this.items,
    required this.questions,
    required this.accent,
    this.listenMode = false,
  }) : super(key: key);

  @override
  State<KidsQuizScreen> createState() => _KidsQuizScreenState();
}

class _KidsQuizScreenState extends State<KidsQuizScreen> {
  final PageController _controller = PageController(initialPage: 0);

  late final int _questionCount =
      math.min(widget.questions.length, widget.items.length);

  int score = 0;
  int _index = 0;
  int _selected = -1;
  bool _answered = false;
  bool _lastCorrect = false;
  bool _turning = false;
  int _burst = 0;

  /// Only created in listen mode, so look-and-choose quizzes never touch the
  /// TTS platform channel.
  FlutterTts? _tts;
  bool _speaking = false;

  @override
  void initState() {
    super.initState();
    unawaited(
      AppServices.analytics.logLevelStarted(
        source: widget.listenMode ? 'listen_guess' : 'look_choose',
        difficulty: widget.title,
      ),
    );
    if (!widget.listenMode || _questionCount == 0) return;

    _tts = FlutterTts()
      ..setCompletionHandler(() => _setSpeaking(false))
      ..setCancelHandler(() => _setSpeaking(false))
      ..setErrorHandler((dynamic _) => _setSpeaking(false));

    WidgetsBinding.instance.addPostFrameCallback((Duration _) => _speak());
  }

  @override
  void dispose() {
    _tts?.stop();
    _controller.dispose();
    super.dispose();
  }

  List<MapEntry<String, bool>> _answers(int pageIndex) {
    return widget.questions[pageIndex].answer.entries.toList();
  }

  /// Answer keys are plain words in look mode and artwork paths in listen
  /// mode, so options are rendered as pictures only when the key is one.
  bool _isAssetPath(String value) => value.startsWith('assets/');

  /// Word the child has to recognise on [pageIndex]. The answer key itself is
  /// an artwork path in listen mode, so the spoken word comes from the item
  /// list and only falls back to the key when the item has no label.
  String _promptFor(int pageIndex) {
    final String? text = widget.items[pageIndex].Text;
    if (text != null && text.trim().isNotEmpty) return text;
    for (final MapEntry<String, bool> entry in _answers(pageIndex)) {
      if (entry.value && !_isAssetPath(entry.key)) return entry.key;
    }
    return '';
  }

  void _setSpeaking(bool value) {
    if (!mounted || _speaking == value) return;
    setState(() => _speaking = value);
  }

  Future<void> _speak() async {
    final FlutterTts? tts = _tts;
    if (tts == null) return;

    final String word = _promptFor(_index);
    if (word.isEmpty) return;

    _setSpeaking(true);
    try {
      await tts.stop();
      await tts.speak(word);
    } catch (_) {
      // A missing / busy TTS engine must never break the quiz.
      _setSpeaking(false);
    }
  }

  bool _isCorrect(int pageIndex, int optionIndex) {
    return _answers(pageIndex)[optionIndex].value;
  }

  KidsOptionState _stateFor(int pageIndex, int optionIndex) {
    if (!_answered || _selected != optionIndex) return KidsOptionState.idle;
    return _isCorrect(pageIndex, optionIndex)
        ? KidsOptionState.correct
        : KidsOptionState.wrong;
  }

  void _answer(int pageIndex, int optionIndex) {
    if (_answered) return;
    final bool correct = _isCorrect(pageIndex, optionIndex);

    setState(() {
      _answered = true;
      _selected = optionIndex;
      _lastCorrect = correct;
      if (correct) {
        score += 1;
        _burst++;
      }
    });

    // KidsQuizOption plays the success chime / soft-wrong wiggle itself when
    // its state flips, so only the extra celebration layer is added here.
    if (correct) KidsSound.instance.sparkle();
  }

  void _advance() {
    if (!_answered || _turning) return;

    if (_index + 1 >= _questionCount) {
      unawaited(
        AppServices.analytics.logLevelCompleted(
          source: widget.listenMode ? 'listen_guess' : 'look_choose',
          difficulty: widget.title,
          moves: score,
        ),
      );
      AdManager().showInterstitial(placement: 'after_quiz');
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              ResultSrceen(score, total: _questionCount),
        ),
      ).then((void _) => _restart());
      return;
    }

    KidsSound.instance.whoosh();
    _turning = true;
    _controller.nextPage(
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeInOut,
    );
  }

  void _restart() {
    if (!mounted) return;
    setState(() {
      score = 0;
      _index = 0;
      _selected = -1;
      _answered = false;
      _lastCorrect = false;
      _turning = false;
    });
    if (_controller.hasClients) _controller.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    if (_questionCount == 0) return const SizedBox.shrink();

    final bool isLast = _index + 1 >= _questionCount;

    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(placement: 'quiz'),
      body: KidsSkyBackground(
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: Column(
                children: <Widget>[
                  _header(),
                  _progress(),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _questionCount,
                      onPageChanged: (int page) {
                        setState(() {
                          _index = page;
                          _selected = -1;
                          _answered = false;
                          _lastCorrect = false;
                          _turning = false;
                        });
                        _speak();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return _question(index);
                      },
                    ),
                  ),
                  _feedback(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 16),
                    child: KidsPrimaryCta(
                      label: isLast ? 'See Result' : 'Next Question',
                      icon: isLast
                          ? Icons.emoji_events_rounded
                          : Icons.arrow_forward_rounded,
                      enabled: _answered,
                      pulse: _answered,
                      onTap: _advance,
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: ConfettiBurst(trigger: _burst),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: Row(
        children: <Widget>[
          KidsCircleNav.back(onTap: () => Navigator.of(context).pop()),
          Expanded(
            child: KidsBubbleTitle.colored(
              widget.title,
              fillColor: widget.accent,
              fontSize: 36,
              maxLines: 1,
            ),
          ),
          KidsQuizScorePill(score: score),
        ],
      ),
    );
  }

  Widget _progress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOut,
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      ((_index + 1) / _questionCount).clamp(0.0, 1.0).toDouble(),
                  heightFactor: 1.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: KidsTheme.candyFill(KidsTheme.correctGreen),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          KidsBubbleTitle(
            '${_index + 1}/$_questionCount',
            fontSize: 20,
            strokeWidth: 4,
          ),
        ],
      ),
    );
  }

  Widget _question(int index) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double artSide =
            (constraints.maxHeight * 0.34).clamp(96.0, 200.0).toDouble();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 8),
              SizedBox(
                height: artSide,
                width: artSide,
                child: KidsPopIn(child: _artCard(index)),
              ),
              const SizedBox(height: 14),
              Expanded(child: _options(index)),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  Widget _artCard(int index) {
    final Numbermodel item = widget.items[index];

    return KidsBounce(
      offset: 7,
      scale: 0.02,
      tilt: 0.012,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: KidsTheme.softFill(widget.accent, strength: 0.22),
          borderRadius: BorderRadius.circular(KidsTheme.radiusTile),
          border: Border.all(color: Colors.white, width: 5),
          boxShadow: KidsTheme.pillowShadow(widget.accent, depth: 5),
        ),
        child: widget.listenMode
            ? _speakerFace()
            : Kids3DLetter.isLetter(item.Text)
                ? Kids3DLetter(
                    letter: item.Text!,
                    size: 150,
                  )
                : Image.asset(
                item.image ?? '',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder:
                    (BuildContext context, Object error, StackTrace? stack) {
                  return Center(
                    child: KidsBubbleTitle(
                      item.Text ?? '?',
                      fontSize: 48,
                      fillColor: KidsTheme.bubbleFillBlue,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
      ),
    );
  }

  /// Listen-mode replacement for the artwork: the word is never shown, only
  /// heard, so the card holds a speaker the child can tap to replay it.
  Widget _speakerFace() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double side = (constraints.biggest.shortestSide * 0.72)
            .clamp(56.0, 132.0)
            .toDouble();
        return Center(
          child: KidsSpeakerButton(
            size: side,
            isPlaying: _speaking,
            onTap: _speak,
          ),
        );
      },
    );
  }

  Widget _options(int index) {
    final List<MapEntry<String, bool>> answers = _answers(index);
    final double fontSize = _optionFontSize(answers);

    final List<Widget> rows = <Widget>[];
    for (int start = 0; start < answers.length; start += 2) {
      final List<Widget> cells = <Widget>[];
      for (int i = start; i < math.min(start + 2, answers.length); i++) {
        if (cells.isNotEmpty) cells.add(const SizedBox(width: 14));
        final String key = answers[i].key;
        final bool asPicture = _isAssetPath(key);
        cells.add(
          Expanded(
            child: KidsPopIn(
              delay: Duration(milliseconds: 70 * i),
              child: KidsQuizOption(
                imageAsset: asPicture ? key : null,
                label: asPicture ? null : key,
                fontSize: fontSize,
                accent: widget.accent,
                state: _stateFor(index, i),
                enabled: !_answered,
                onTap: () => _answer(index, i),
              ),
            ),
          ),
        );
      }
      // Keep a half-filled row aligned with the grid above it.
      while (cells.length < 3) {
        cells.add(const SizedBox(width: 14));
        cells.add(const Expanded(child: SizedBox.shrink()));
      }

      if (rows.isNotEmpty) rows.add(const SizedBox(height: 14));
      rows.add(Expanded(child: Row(children: cells)));
    }

    return Column(children: rows);
  }

  /// Category answers range from "Cat" to "European-goldfinch", so the option
  /// text is stepped down for the long ones instead of being ellipsised.
  double _optionFontSize(List<MapEntry<String, bool>> answers) {
    int longest = 0;
    for (final MapEntry<String, bool> entry in answers) {
      if (_isAssetPath(entry.key)) continue;
      if (entry.key.length > longest) longest = entry.key.length;
    }
    if (longest > 14) return 17;
    if (longest > 10) return 20;
    if (longest > 6) return 23;
    return 26;
  }

  Widget _feedback() {
    return SizedBox(
      height: 46,
      child: !_answered
          ? null
          : Center(
              child: KidsPopIn(
                key: ValueKey<String>('$_index-$_selected'),
                child: KidsBubbleTitle(
                  _lastCorrect ? 'Yay! Well Done!' : 'Nice try!',
                  fontSize: 28,
                  fillColor: _lastCorrect
                      ? const Color(0xFFDFFFD6)
                      : const Color(0xFFFFF0D6),
                  outlineColor: _lastCorrect
                      ? KidsTheme.darken(KidsTheme.correctGreen, 0.24)
                      : KidsTheme.darken(KidsTheme.nextOrange, 0.20),
                  maxLines: 1,
                ),
              ),
            ),
    );
  }
}

/// Little white "stars collected" chip shown in the quiz header.
class KidsQuizScorePill extends StatelessWidget {
  final int score;

  const KidsQuizScorePill({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KidsTheme.radiusPillSmall),
        border: Border.all(color: KidsTheme.speakerYellow, width: 3),
        boxShadow: KidsTheme.softShadow(y: 3, blur: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.star_rounded, size: 22, color: Color(0xFFFFC93C)),
          const SizedBox(width: 4),
          Text(
            '$score',
            style: KidsTheme.label(fontSize: 22),
          ),
        ],
      ),
    );
  }
}
