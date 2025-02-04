import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/ColorSound.dart';
import 'package:kids/utils/app_constrant.dart';
import 'package:kids/utils/model.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Color extends StatefulWidget {
  // int index;
  Color({Key? key}) : super(key: key);
  @override
  State<Color> createState() => _ColorState();
}

final FlutterTts flutterTts = FlutterTts();

class _ColorState extends State<Color> {
  List<Numbermodel> colorlist = COLOR1();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: LetsStartLearningTextColor),
          backgroundColor: LetsStartLearningbgcolor,
          elevation: 0,
          title: Center(
              child: Text(
            'Color',
            style: TextStyle(
                color: LetsStartLearningTextColor, fontFamily: "arlrdbd"),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: GridView.builder(
              itemCount: colorlist.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    // splashColor: Colors.redAccent,
                    onTap: () {
                      print(colorlist);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ColorSound(index),
                          ));
                    },
                    child: Card(
                      color: LetsStartLearningbgcolor,
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      shadowColor: LetsStartLearningTextColor,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              colorlist[index].image!,
                              height: 120,
                            ),
                            Text(
                              colorlist[index].Text!,
                              style: TextStyle(
                                  color: LetsStartLearningTextColor,
                                  fontFamily: "arlrdbd"),
                            )
                          ]),
                    ));
              },
            ),
          ),
        ));
  }
}
