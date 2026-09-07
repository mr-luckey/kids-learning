import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids/Pages/LetsStartLearning.dart';
import 'package:kids/Pages/LookAndChooes.dart';
import 'package:kids/Pages/listen_and_guess.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_engaging_card.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

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
    KidsSound.instance.preload();
  }

  Future<void> _openStore() async {
    final Uri uri = Uri.parse(_storeUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
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
          child: KidsPopIn(
            child: Container(
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
                    child: Image.asset(
                      'assets/ui/rate_star_3d.png',
                      height: 72,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.emoji_emotions_rounded,
                        size: 64,
                        color: KidsTheme.tileLookChoose,
                      ),
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
                  KidsPrimaryCta(
                    label: 'Keep Playing',
                    color: KidsTheme.tileStartLearning,
                    icon: Icons.play_arrow_rounded,
                    height: 58,
                    fontSize: 20,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Exit',
                      style: TextStyle(
                        fontFamily: KidsTheme.fontFamily,
                        fontSize: 18,
                        color: KidsTheme.wrongRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitPopup,
      child: Scaffold(
        backgroundColor: KidsTheme.skyTop,
        body: KidsSkyBackground(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _header(),
                    Expanded(child: _tileGrid()),
                    const SizedBox(height: 88),
                  ],
                ),
                // Floating cartoon Rate Us — bottom right
                Positioned(
                  right: 14,
                  bottom: 14,
                  child: KidsFloatingRateUs(onTap: _openStore),
                ),
                // Friendly sun / character — bottom left (not app logo on a button)
                Positioned(
                  left: 10,
                  bottom: 18,
                  child: KidsBounce(
                    offset: 8,
                    tilt: 0.05,
                    child: Image.asset(
                      'assets/images/sun.png',
                      height: 70,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.wb_sunny_rounded,
                        size: 64,
                        color: KidsTheme.speakerYellow,
                      ),
                    ),
                  ),
                ),
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
          const SizedBox(width: 8),
          KidsBounce(
            offset: 7,
            tilt: 0.04,
            child: Image.asset(
              'assets/ui/letter_A.png',
              height: 64,
              width: 64,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.wb_sunny_rounded,
                size: 56,
                color: KidsTheme.speakerYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tileGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 14,
        childAspectRatio: 0.78,
        children: <Widget>[
          KidsPopIn(
            child: KidsEngagingCard(
              label: 'Start Learning',
              color: KidsTheme.tileStartLearning,
              imageAsset: 'assets/ui/home_start_3d.png',
              icon: Icons.school_rounded,
              bounceDelay: Duration.zero,
              onTap: () => _go(() => LetsStartLearning()),
            ),
          ),
          KidsPopIn(
            delay: const Duration(milliseconds: 90),
            child: KidsEngagingCard(
              label: 'Fun Quiz',
              color: KidsTheme.tileFunQuiz,
              imageAsset: 'assets/ui/home_fun_quiz_3d.png',
              icon: Icons.extension_rounded,
              bounceDelay: const Duration(milliseconds: 500),
              onTap: () => _go(() => LookAndChooes(0)),
            ),
          ),
          KidsPopIn(
            delay: const Duration(milliseconds: 180),
            child: KidsEngagingCard(
              label: 'Look And Choose',
              color: KidsTheme.tileLookChoose,
              imageAsset: 'assets/ui/home_look_3d.png',
              icon: Icons.touch_app_rounded,
              bounceDelay: const Duration(milliseconds: 1000),
              onTap: () => _go(() => LookAndChooes(0)),
            ),
          ),
          KidsPopIn(
            delay: const Duration(milliseconds: 270),
            child: KidsEngagingCard(
              label: 'Listen and Guess',
              color: KidsTheme.tileListenGuess,
              imageAsset: 'assets/ui/home_listen_3d.png',
              icon: Icons.hearing_rounded,
              bounceDelay: const Duration(milliseconds: 1500),
              onTap: () => _go(() => ListenGuess()),
            ),
          ),
        ],
      ),
    );
  }
}
