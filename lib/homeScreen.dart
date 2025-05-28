import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kids/Pages/LetsStartLearning.dart';
import 'package:kids/utils/ad_helper.dart';
import 'package:kids/utils/admob.dart';
import 'package:kids/utils/app_constrant.dart';
import 'package:kids/utils/video.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Pages/LookAndChooes.dart';
import 'Pages/VideoLearning.dart';
import 'Pages/listen_and_guess.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final AdmobHelper _admobHelper = AdmobHelper();
  Timer? _adTimer;

  @override
  void initState() {
    super.initState();

    // _admobHelper.createInterad(); // Load first ad

    // Show ad every 10 seconds
    _adTimer = Timer.periodic(const Duration(seconds: 40), (Timer timer) {
      // _admobHelper.showInterad();
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
    Size size = MediaQuery.of(context).size;

    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Exit App',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              content: const Text(
                'Do you want to exit an App?',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
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
          floatingActionButton: FloatingActionButton(
            // highlightElevation: 20,
            onPressed: () {
              _openMap();
            },
            child: const Icon(
              Icons.star,
              color: Colors.black,
            ),
            backgroundColor: const Color.fromARGB(255, 146, 239, 166),
          ),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 146, 239, 166),
            title: const Center(
              child: Text(
                "Kids Learning",
                style: TextStyle(
                    fontFamily: "arlrdbd",
                    fontSize: 30,
                    color: Color.fromARGB(255, 5, 174, 41)),
              ),
            ),
          ),
          body: Center(
            child: Column(
              children: [
                const VideoApp(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 15,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => LetsStartLearning());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 220, 255, 228),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/number.png",
                                    height: 100,
                                  ),
                                  const Text(
                                    'Start Learning',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "arlrdbd",
                                        color: Color.fromARGB(255, 5, 174, 41)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => VideoLearning());
                              // admobHelper.showInterad();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => VideoLearning()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 237, 223),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/video.png",
                                    height: 100,
                                  ),
                                  const Text(
                                    'Video Learning',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "arlrdbd",
                                        color: Color(0xFFEC9E4E)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => LookAndChooes(index));
                              // admobHelper.showInterad();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             LookAndChooes(index)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 250, 230),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/apple.png",
                                    height: 100,
                                  ),
                                  const Text(
                                    'Look And Choose',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "arlrdbd",
                                        color:
                                            Color.fromARGB(255, 255, 217, 46)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => ListenGuess());
                              // admobHelper.showInterad();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => ListenGuess()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 239, 236, 255),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/lione.png",
                                    height: 100,
                                  ),
                                  const Text(
                                    'Listen and Guess',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "arlrdbd",
                                        color: Color(0xFF8770E4)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
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
