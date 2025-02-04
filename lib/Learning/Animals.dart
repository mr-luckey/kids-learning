import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/AnimalsSound.dart';
import 'package:kids/utils/app_constrant.dart';
import 'package:kids/utils/model.dart';

class Animal extends StatefulWidget {
  @override
  State<Animal> createState() => _AnimalState();
}

List<Numbermodel> animallist = ANIMAL1();

class _AnimalState extends State<Animal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: LetsStartLearningTextColor),
          backgroundColor: LetsStartLearningbgcolor,
          elevation: 0,
          title: Center(
              child: Text(
            'Animal',
            style: TextStyle(
                color: LetsStartLearningTextColor, fontFamily: "arlrdbd"),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: GridView.builder(
              itemCount: animallist.length,
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
                      // print(animallist);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnimalSound(index),
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
                              animallist[index].image!,
                              height: 120,
                            ),
                            Text(
                              animallist[index].Text!,
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
