import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:kids/bottomnavigation.dart';
import 'package:kids/utils/model.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:quickalert/quickalert.dart';

class AlphabetSong extends StatefulWidget {
  @override
  State<AlphabetSong> createState() => _AlphabetSongState();
}

List<Numbermodel> abcsongs1 = abcsongs();

class _AlphabetSongState extends State<AlphabetSong> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPressed = false;
  Color istrue = Colors.green;
  Color isWrong = Colors.red;
  Color btnColor = Colors.blue;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    PageController _controller = new PageController(initialPage: 0);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Color(0xFFFEF7F0),
            title: Center(
              child: Text(
                'Alphabet',
                style: TextStyle(color: Colors.black, fontFamily: "arlrdbd"),
              ),
            )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (page) {
                    isPressed = false;
                  },
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: alphasongs2.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        Image.asset("assets/images/volume.png"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            abcsongs1[index].Text!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontFamily: "arlrdbd"),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        Expanded(
                          child: GridView.count(
                            padding: EdgeInsets.all(50),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 15,
                            crossAxisCount: 2,
                            physics: NeverScrollableScrollPhysics(),
                            primary: false,
                            children: [
                              for (int i = 0;
                                  i < alphasongs2[index].answer.length;
                                  i++)
                                MaterialButton(
                                  shape: BeveledRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  elevation: 5.0,
                                  height: 10,
                                  minWidth: double.infinity,
                                  color: isPressed
                                      ? alphasongs2[index]
                                              .answer
                                              .entries
                                              .toList()[i]
                                              .value
                                          ? istrue
                                          : isWrong
                                      : Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  onPressed: isPressed
                                      ? () {}
                                      : () {
                                          if (alphasongs2[index]
                                              .answer
                                              .entries
                                              .toList()[i]
                                              .value) {
                                            setState(() {
                                              isPressed = true;
                                            });
                                            score += 1;
                                            QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.success,
                                              title: 'Correct',
                                              // showCancelBtn: false,
                                              autoCloseDuration:
                                                  const Duration(seconds: 1),
                                            );
                                            // print(score);
                                            // MotionToast.success(
                                            //     borderRadius: 5,
                                            //     animationDuration: Duration(seconds: 3),
                                            //     title: Text("Your Answer is Right",style: TextStyle(fontSize: 20),),
                                            //     iconType: IconType.cupertino
                                            // ).show(context);
                                          } else {
                                            setState(() {
                                              isPressed = true;
                                            });
                                            QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.error,
                                                title: 'Wrong',
//   text: 'Thats a wrong answer',
// showCancelBtn: false,

                                                autoCloseDuration:
                                                    Duration(seconds: 1));
                                            // MotionToast.error(
                                            //     borderRadius: 5,
                                            //     animationDuration: Duration(seconds: 6),
                                            //     title: Text("Your Answer is Wrong",style: TextStyle(fontSize: 20),),
                                            //     iconType: IconType.cupertino,
                                            // ).show(context);
                                          }
                                        },
                                  child: Image(
                                    image: AssetImage(alphasongs2[index]
                                        .answer
                                        .keys
                                        .toList()[i]),
                                    height: 100,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () =>
                                      flutterTts.speak(abcsongs1[index].Text!),
                                  child: Image.asset(
                                      'assets/images/11MaskGroup3.png')),
                              Center(
                                  child: ListTile(
                                trailing: InkWell(
                                  onTap: isPressed
                                      ? index + 1 == questions.length
                                          ? () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResultSrceen(score)));
                                            }
                                          : () {
                                              _controller.nextPage(
                                                  duration: Duration(
                                                      microseconds: 500),
                                                  curve: Curves.linear);
                                              flutterTts.speak(
                                                  abcsongs1[index + 1].Text!);
                                            }
                                      : null,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/11MaskGroup5.png'),
                                  ),
                                ),
                                leading: InkWell(
                                  onTap: isPressed
                                      ? index - 1 == questions.length
                                          ? () {}
                                          : () {
                                              _controller.previousPage(
                                                  duration: Duration(
                                                      microseconds: 500),
                                                  curve: Curves.linear);
                                              flutterTts.speak(
                                                  abcsongs1[index - 1].Text!);
                                            }
                                      : null,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/11MaskGroup4.png'),
                                  ),
                                ),
                              )),
                            ]),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class ResultSrceen extends StatefulWidget {
  final int score;
  ResultSrceen(this.score);
  @override
  _ResultSrceenState createState() => _ResultSrceenState();
}

class _ResultSrceenState extends State<ResultSrceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "Congratulation",
            style: TextStyle(
                color: Colors.redAccent, fontFamily: "arlrdbd", fontSize: 38.0),
          )),
          Center(
              child: Text(
            "Your Score is:",
            style: TextStyle(
                color: Colors.redAccent,
                fontFamily: "arlrdbd",
                fontSize: 25.0,
                fontWeight: FontWeight.w500),
          )),
          SizedBox(
            height: 50.0,
          ),
          Center(
              child: Text(
            "${widget.score}",
            style: TextStyle(
                color: Colors.redAccent, fontFamily: "arlrdbd", fontSize: 80.0),
          )),
          GestureDetector(
            onTap: () => Get.to(BottomNav()),
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.redAccent)),
              child: Center(
                  child: Text(
                "OK",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontFamily: "arlrdbd",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              )),
            ),
          )
        ],
      ),
    );
  }
}
