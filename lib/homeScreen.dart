import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kids/Pages/LetsStartLearning.dart';
import 'package:kids/utils/ad_helper.dart';
import 'package:kids/utils/app_constrant.dart';
import 'package:kids/utils/video.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_button.dart';
import 'package:kids/widgets/adventure_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Pages/LookAndChooes.dart';
import 'Pages/VideoLearning.dart';
import 'Pages/listen_and_guess.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _adTimer;
  final AdManager _adManager = AdManager();

  @override
  void initState() {
    super.initState();

    // Show ad every 5 minutes (300 seconds) - reasonable frequency
    _adTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_adManager.isAdReady() && _adManager.canShowAd()) {
        _adManager.showCustomInterstitialAd(context);
      }
    });
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    super.dispose();
  }

  String url = "https://play.google.com/store/apps/details?id=" +
      "com.appware.kidslearning";
  int index = 0;
  // AdmobHelper admobHelper = new AdmobHelper();
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                'See you soon! 👋',
                style: TextStyle(
                  fontFamily: "arlrdbd",
                  color: Color(0xFF1A5F7A),
                  fontSize: 24,
                ),
              ),
              content: const Text(
                'Are you sure you want to leave?',
                style: TextStyle(
                  fontFamily: "arlrdbd",
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Stay'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: appBarStart,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Exit'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return OverflowBar(children: [
      WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [scaffoldBgStart, scaffoldBgEnd],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Gradient app bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [appBarStart, appBarEnd],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cardShadowColor,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Kids Learning",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "arlrdbd",
                        fontSize: 28,
                        color: Color(0xFF1A5F7A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const VideoApp(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.85,
                              children: [
                                _buildMenuCard(
                                  onTap: () =>
                                      Get.to(() => LetsStartLearning()),
                                  gradient: const [
                                    Color(0xFFD4F5DC),
                                    Color(0xFFA8E6CF),
                                  ],
                                  image: "assets/images/number.png",
                                  label: 'Start Learning',
                                  textColor: const Color(0xFF2E7D32),
                                ),
                                _buildMenuCard(
                                  onTap: () => Get.to(() => VideoLearning()),
                                  gradient: const [
                                    Color(0xFFFFE5D9),
                                    Color(0xFFFFDAB9),
                                  ],
                                  image: "assets/images/video.png",
                                  label: 'Video Learning',
                                  textColor: const Color(0xFFE85D4C),
                                ),
                                _buildMenuCard(
                                  onTap: () =>
                                      Get.to(() => LookAndChooes(index)),
                                  gradient: const [
                                    Color(0xFFFFF9E3),
                                    Color(0xFFFFEAA7),
                                  ],
                                  image: "assets/images/apple.png",
                                  label: 'Look And Choose',
                                  textColor: const Color(0xFFD4A017),
                                ),
                                _buildMenuCard(
                                  onTap: () => Get.to(() => ListenGuess()),
                                  gradient: const [
                                    Color(0xFFE8E0F0),
                                    Color(0xFFD4C5F9),
                                  ],
                                  image: "assets/images/lione.png",
                                  label: 'Listen and Guess',
                                  textColor: const Color(0xFF6B5B95),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openMap,
            icon: const Icon(Icons.star_rounded, color: Colors.white),
            label: const Text(
              'Rate us',
              style: TextStyle(
                fontFamily: "arlrdbd",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: appBarStart,
            elevation: 4,
          ),
        ),
      ),
    ]);
  }

  Widget _buildMenuCard({
    required VoidCallback onTap,
    required List<Color> gradient,
    required String image,
    required String label,
    required Color textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: cardShadowColor,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, height: 88),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "arlrdbd",
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openMap() async {
    const url = "https://play.google.com/store/apps/details?id=" +
        "com.appware.kidlearning";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
