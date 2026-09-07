import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kids/privacypolicy.dart';
import 'package:kids/utils/banner_ad_widget.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_card.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final flutterWebviewPlugin = new PrivacyPolicy();

  _openMap() async {
    const url = "https://play.google.com/store/apps/details?id=" +
        "com.appware.kidlearning";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _Share() async {
    Share.share("https://play.google.com/store/apps/details?id=" +
        "com.appware.kidlearning");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      body: AdventureBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: const Color(0xFF1A5F7A),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: AdventureTitle(
                        text: 'Settings',
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
        child: Column(
          children: [
            Container(
              height: size.height * 0.3,
              child: Stack(
                children: [
                  Container(
                      height: size.height * 0.3 - 27,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFEF7F0),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(36),
                              bottomRight: Radius.circular(36))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/sun.png"),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Good",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: "arlrdbd",
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Morning!",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: "arlrdbd",
                                      color: Color(0xFFF19335),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
              Padding(
              padding: const EdgeInsets.all(12.0),
              child: AdventureCard(
                onTap: _openMap,
                gradientColors: const [
                  Color(0xFFD4F5DC),
                  Color(0xFFA8E6CF),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: Color(0xFF2E7D32), size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Rate Us',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontFamily: "arlrdbd",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AdventureCard(
                onTap: _Share,
                gradientColors: const [
                  Color(0xFFFFF9E3),
                  Color(0xFFFFEAA7),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.share_rounded, color: Color(0xFFD4A017), size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Share',
                        style: TextStyle(
                          color: Color(0xFFD4A017),
                          fontFamily: "arlrdbd",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
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
    );
  }
}
