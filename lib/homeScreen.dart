import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/Pages/LetsStartLearning.dart';
import 'package:kids/utils/admob.dart';
import 'package:kids/utils/app_constrant.dart';
import 'package:kids/utils/video.dart';
import 'Pages/LookAndChooes.dart';
import 'Pages/VideoLearning.dart';
import 'Pages/listen_and_guess.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = "https://play.google.com/store/apps/details?id=" +
      "com.appware.kidslearning";
  int index = 0;
  AdmobHelper admobHelper = new AdmobHelper();
  @override
  void initState() {
    super.initState();
    admobHelper.createInterad();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Exit App',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              content: Text(
                'Do you want to exit an App?',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
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
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 146, 239, 166),
            title: const Center(
              child: Text(
                "Welcome to Kids Learning",
                style: TextStyle(
                    fontFamily: "arlrdbd",
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            // elevation: 0,
          ),
          body: Center(
            child: Column(
              children: [
                VideoApp(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.count(
                        // physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 15,
                        children: [
                          InkWell(
                            onTap: () {
                              admobHelper.showInterad();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LetsStartLearning(index)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: appcolor),
                                color: Color(0xFFE4F2E6),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/number.png",
                                    height: 90,
                                  ),
                                  Text(
                                    'Lets Start Learning',
                                    style: TextStyle(
                                        fontFamily: "arlrdbd",
                                        color: Color(0xFF6DB072)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              admobHelper.showInterad();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoLearning()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFF9F4),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: appcolor)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/video.png",
                                    height: 90,
                                  ),
                                  Text(
                                    'Video Learning',
                                    style: TextStyle(
                                        fontFamily: "arlrdbd",
                                        color: Color(0xFFEC9E4E)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              admobHelper.showInterad();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LookAndChooes(index)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: appcolor),
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/apple.png",
                                    height: 90,
                                  ),
                                  Text(
                                    'Look And Choose',
                                    style: TextStyle(
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
                              admobHelper.showInterad();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListenGuess()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: appcolor),
                                color: Color(0xFFEBE8FD),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/lione.png",
                                    height: 90,
                                  ),
                                  Text(
                                    'Listen and Guess',
                                    style: TextStyle(
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
}
