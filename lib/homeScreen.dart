import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids/Pages/LetsStartLearning.dart';
import 'package:kids/Pages/LookAndChooes.dart';
import 'package:kids/Pages/listen_and_guess.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Activity selection screen: a 2x2 grid of big candy tiles on the animated
/// sky + meadow background.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _storeUrl =
      'https://play.google.com/store/apps/details?id=com.appware.kidslearning';

  @override
  void initState() {
    super.initState();
    // Warms the audio players so the very first tap clicks instantly.
    KidsSound.instance.preload();
  }

  Future<void> _openStore() async {
    final Uri uri = Uri.parse(_storeUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // A missing browser / store app must never crash the home screen.
    }
  }

  void _go(Widget Function() page) {
    KidsSound.instance.whoosh();
    Get.to(page);
  }

  Future<bool> _showExitPopup() async {
    final bool? leave = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black45,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: KidsPopIn(child: _exitCard(context)),
        );
      },
    );
    return leave ?? false;
  }

  Widget _exitCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: KidsTheme.softFill(KidsTheme.backBlue, strength: 0.3),
        borderRadius: BorderRadius.circular(KidsTheme.radiusTile),
        border: Border.all(color: KidsTheme.backBlue, width: 5),
        boxShadow: KidsTheme.pillowShadow(KidsTheme.backBlue, depth: 6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          KidsBounce(
            offset: 5,
            child: Image.asset(
              'assets/images/logo.png',
              height: 78,
              errorBuilder: (BuildContext c, Object e, StackTrace? s) {
                return const Icon(
                  Icons.emoji_emotions_rounded,
                  size: 70,
                  color: KidsTheme.tileLookChoose,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const KidsBubbleTitle('See you soon!', fontSize: 32),
          const SizedBox(height: 10),
          Text(
            'Do you want to stop playing?',
            textAlign: TextAlign.center,
            style: KidsTheme.label(fontSize: 19),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: KidsPrimaryCta(
                  label: 'Keep Playing',
                  color: KidsTheme.tileStartLearning,
                  icon: Icons.play_arrow_rounded,
                  height: 60,
                  fontSize: 20,
                  onTap: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 12),
              KidsCircleNav(
                direction: KidsNavDirection.close,
                color: KidsTheme.wrongRed,
                size: 60,
                onTap: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitPopup,
      child: Scaffold(
        backgroundColor: KidsTheme.skyTop,
        body: KidsSkyBackground(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                _header(),
                Expanded(child: _tileGrid()),
                _footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 4),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: KidsBubbleTitle(
              'Kids Learning',
              fontSize: 40,
              maxLines: 2,
              rimColor: Colors.white,
              fillColor: KidsTheme.bubbleFillBlue,
            ),
          ),
          const SizedBox(width: 10),
          KidsBounce(
            offset: 7,
            tilt: 0.04,
            child: Image.asset(
              'assets/images/sun.png',
              height: 68,
              width: 68,
              fit: BoxFit.contain,
              errorBuilder: (BuildContext c, Object e, StackTrace? s) {
                return const Icon(
                  Icons.wb_sunny_rounded,
                  size: 60,
                  color: KidsTheme.speakerYellow,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tileGrid() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double gap = 16;
        const EdgeInsets pad = EdgeInsets.fromLTRB(18, 8, 18, 8);

        final double cellWidth =
            (constraints.maxWidth - pad.horizontal - gap) / 2;
        final double cellHeight =
            (constraints.maxHeight - pad.vertical - gap) / 2;
        // Fill the available height when we can, but never squash the tiles
        // into letterboxes on very short screens — the grid scrolls instead.
        final double aspect = (cellHeight > 0 && cellWidth > 0)
            ? (cellWidth / cellHeight).clamp(0.74, 1.15)
            : 1.0;

        return GridView.count(
          padding: pad,
          crossAxisCount: 2,
          mainAxisSpacing: gap,
          crossAxisSpacing: gap,
          childAspectRatio: aspect,
          children: <Widget>[
            KidsPopIn(
              child: KidsHomeTile(
                label: 'Start Learning',
                color: KidsTheme.tileStartLearning,
                imageAsset: 'assets/images/number.png',
                icon: Icons.school_rounded,
                bounceDelay: Duration.zero,
                onTap: () => _go(() => LetsStartLearning()),
              ),
            ),
            KidsPopIn(
              delay: const Duration(milliseconds: 90),
              child: KidsHomeTile(
                label: 'Fun Quiz',
                color: KidsTheme.tileFunQuiz,
                imageAsset: 'assets/images/logo.png',
                icon: Icons.extension_rounded,
                bounceDelay: const Duration(milliseconds: 550),
                onTap: () => _go(() => LookAndChooes(0)),
              ),
            ),
            KidsPopIn(
              delay: const Duration(milliseconds: 180),
              child: KidsHomeTile(
                label: 'Look And Choose',
                color: KidsTheme.tileLookChoose,
                imageAsset: 'assets/images/apple.png',
                icon: Icons.touch_app_rounded,
                bounceDelay: const Duration(milliseconds: 1100),
                onTap: () => _go(() => LookAndChooes(0)),
              ),
            ),
            KidsPopIn(
              delay: const Duration(milliseconds: 270),
              child: KidsHomeTile(
                label: 'Listen and Guess',
                color: KidsTheme.tileListenGuess,
                imageAsset: 'assets/images/lione.png',
                icon: Icons.hearing_rounded,
                bounceDelay: const Duration(milliseconds: 1650),
                onTap: () => _go(() => ListenGuess()),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          KidsBounce(
            offset: 9,
            tilt: 0.05,
            child: Image.asset(
              'assets/images/logo.png',
              height: 76,
              fit: BoxFit.contain,
              errorBuilder: (BuildContext c, Object e, StackTrace? s) {
                return const Icon(
                  Icons.emoji_emotions_rounded,
                  size: 66,
                  color: Colors.white,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: KidsRateButton(
              label: 'Rate us',
              onTap: _openStore,
            ),
          ),
        ],
      ),
    );
  }
}
