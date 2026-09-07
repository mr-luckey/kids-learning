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
          horizon: 0.78,
          cloudCount: 6,
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _hero(),
                    Expanded(child: _playboard()),
                    const SizedBox(height: 96),
                  ],
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: KidsFloatingRateUs(onTap: _openStore),
                ),
                Positioned(
                  left: 8,
                  bottom: 14,
                  child: KidsBounce(
                    offset: 9,
                    tilt: 0.06,
                    child: Image.asset(
                      'assets/ui/sun_3d.png',
                      height: 78,
                      errorBuilder: (_, __, ___) => Image.asset(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Brand-forward hero: one candy composition with title + mascot.
  Widget _hero() {
    final BorderRadius radius = BorderRadius.circular(34);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: KidsPopIn(
        child: Container(
          height: 148,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFFFFFFFF),
                Color(0xFFE8F7FF),
                Color(0xFFFFF6D6),
              ],
              stops: <double>[0.0, 0.55, 1.0],
            ),
            borderRadius: radius,
            border: Border.all(color: KidsTheme.backBlue, width: 5),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: KidsTheme.darken(KidsTheme.backBlue, 0.12).withOpacity(0.85),
                blurRadius: 0,
                offset: const Offset(0, 7),
              ),
              BoxShadow(
                color: KidsTheme.backBlue.withOpacity(0.32),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 56,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -36,
                  left: -28,
                  child: IgnorePointer(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: KidsTheme.tileStartLearning.withOpacity(0.16),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 110,
                  child: Row(
                    children: List<Widget>.generate(3, (int i) {
                      return Container(
                        width: 9,
                        height: 9,
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: KidsTheme.backBlue.withOpacity(0.35 + i * 0.18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 1.2,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 10, 14),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const KidsBubbleTitle(
                              'Kids Learning',
                              fontSize: 36,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              rimColor: Colors.white,
                              fillColor: KidsTheme.bubbleFillBlue,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Play · Learn · Smile',
                              style: KidsTheme.label(
                                fontSize: 16,
                                color: KidsTheme.inkDark.withOpacity(0.72),
                              ),
                            ),
                          ],
                        ),
                      ),
                      KidsBounce(
                        offset: 8,
                        tilt: 0.05,
                        child: Container(
                          width: 108,
                          height: 108,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: <Color>[
                                Colors.white.withOpacity(0.95),
                                KidsTheme.backBlue.withOpacity(0.18),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Image.asset(
                            'assets/ui/letter_A.png',
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.wb_sunny_rounded,
                              size: 72,
                              color: KidsTheme.speakerYellow,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Soft frosted playboard holding the four activity tiles.
  Widget _playboard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.white.withOpacity(0.55),
              Colors.white.withOpacity(0.28),
              Colors.white.withOpacity(0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: Colors.white.withOpacity(0.85), width: 3),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: <Widget>[
                  KidsBounce(
                    offset: 4,
                    child: Image.asset(
                      'assets/ui/letter_A.png',
                      height: 36,
                      width: 36,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pick a fun adventure!',
                      style: KidsTheme.label(
                        fontSize: 18,
                        color: KidsTheme.inkDark.withOpacity(0.9),
                      ),
                    ),
                  ),
                  KidsBounce(
                    delay: const Duration(milliseconds: 400),
                    offset: 4,
                    child: Image.asset(
                      'assets/ui/letter_Z.png',
                      height: 36,
                      width: 36,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _tileGrid()),
          ],
        ),
      ),
    );
  }

  Widget _tileGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
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
