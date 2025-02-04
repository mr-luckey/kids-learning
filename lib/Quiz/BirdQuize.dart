import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/utils/app_constrant.dart';
import 'package:kids/utils/model.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:quickalert/quickalert.dart';

import 'ABCQuize.dart';

class Birdquiz extends StatefulWidget {
  @override
  State<Birdquiz> createState() => _BirdquizState();
}

List<Numbermodel> bridslist = BRIDS1();

class _BirdquizState extends State<Birdquiz> {
  bool isPressed = false;
  Color istrue = Color.fromARGB(255, 65, 255, 7);
  Color isWrong = Color(0xFFFF0000);
  Color btnColor = Colors.blue;
  int score = 0;
  @override
  Widget build(BuildContext context) {
    PageController _controller = new PageController(initialPage: 0);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: LookAndChooestextcolor,
          ),
          backgroundColor: LookAndChooesbgcolor,
          title: Center(
              child: Text(
            'Alphabet',
            style:
                TextStyle(fontFamily: "arlrdbd", color: LookAndChooestextcolor),
          )),
        ),
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
                  itemCount: birdquestion.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        Image.asset(
                          bridslist[index].image!,
                          height: 180,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                        Expanded(
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(50),
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            crossAxisCount: 2,
                            primary: false,
                            children: [
                              for (int i = 0;
                                  i < birdquestion[index].answer.length;
                                  i++)
                                MaterialButton(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  elevation: 10.0,
                                  minWidth: double.infinity,
                                  color: isPressed
                                      ? birdquestion[index]
                                              .answer
                                              .entries
                                              .toList()[i]
                                              .value
                                          ? istrue
                                          : isWrong
                                      : Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 18.0),
                                  onPressed: isPressed
                                      ? () {}
                                      : () {
                                          if (birdquestion[index]
                                              .answer
                                              .entries
                                              .toList()[i]
                                              .value) {
                                            setState(() {
                                              isPressed = true;
                                            });
                                            score += 1;
                                          } else {
                                            setState(() {
                                              isPressed = true;
                                            });
                                          }
                                        },
                                  child: Text(
                                    birdquestion[index].answer.keys.toList()[i],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "arlrdbd",
                                        fontSize: 20.0),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              heightFactor: 5,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: isPressed
                                    ? index + 1 == birdquestion.length
                                        ? () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResultSrceen(score)));
                                          }
                                        : () {
                                            _controller.nextPage(
                                                duration:
                                                    Duration(microseconds: 500),
                                                curve: Curves.linear);
                                          }
                                    : null,
                                child: Text(
                                  index + 1 == birdquestion.length
                                      ? "See Result"
                                      : "Next Question",
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    color: LookAndChooestextcolor,
                                    fontFamily: "arlrdbd",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
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
