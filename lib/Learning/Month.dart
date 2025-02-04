import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/MonthSound.dart';
import 'package:kids/utils/app_constrant.dart';
import 'package:kids/utils/model.dart';

class Month extends StatelessWidget {
  List<Numbermodel> monthlist = month1();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: LetsStartLearningTextColor),
          backgroundColor: LetsStartLearningbgcolor,
          elevation: 0,
          title: Center(
              child: Text(
            'Month',
            style: TextStyle(
                color: LetsStartLearningTextColor, fontFamily: "arlrdbd"),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: GridView.builder(
              itemCount: monthlist.length,
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
                      // print(monthlist);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MonthSound(index),
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
                              monthlist[index].image!,
                              height: 120,
                            ),
                            Text(
                              monthlist[index].Text!,
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
