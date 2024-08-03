import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/BridSound.dart';
import 'package:kids/utils/model.dart';

class Brids extends StatefulWidget {
  @override
  State<Brids> createState() => _BridsState();
}

List<Numbermodel> bridslist = BRIDS1();

class _BridsState extends State<Brids> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.orange[50],
          elevation: 0,
          title: Center(
              child: Text(
            'Bird',
            style: TextStyle(color: Colors.black, fontFamily: "arlrdbd"),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: GridView.builder(
              itemCount: bridslist.length,
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
                    splashColor: Colors.redAccent,
                    onTap: () {
                      print(bridslist);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BridSound(index),
                          ));
                    },
                    child: Card(
                      color: Color(0xFFFEF9E4),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      shadowColor: Colors.redAccent,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              bridslist[index].image!,
                              height: 120,
                            ),
                            Text(
                              bridslist[index].Text!,
                              style: TextStyle(
                                  color: Colors.black, fontFamily: "arlrdbd"),
                            )
                          ]),
                    ));
              },
            ),
          ),
        ));
  }
}
