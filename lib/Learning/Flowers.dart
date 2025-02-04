import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/FlowerSound.dart';
import 'package:kids/utils/app_constrant.dart';
import 'package:kids/utils/model.dart';

class Flower extends StatefulWidget {
  @override
  State<Flower> createState() => _FlowerState();
}

List<Numbermodel> flowerlist = FLOWERS1();

class _FlowerState extends State<Flower> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: LetsStartLearningTextColor),
          backgroundColor: LetsStartLearningbgcolor,
          elevation: 0,
          title: Center(
              child: Text(
            'Flower',
            style: TextStyle(
                color: LetsStartLearningTextColor, fontFamily: "arlrdbd"),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: GridView.builder(
              itemCount: flowerlist.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return InkWell(
                    // splashColor: Colors.redAccent,
                    onTap: () {
                      print(Flower);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlowerSound(index),
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
                              flowerlist[index].image!,
                              height: 120,
                            ),
                            Text(
                              flowerlist[index].Text!,
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
