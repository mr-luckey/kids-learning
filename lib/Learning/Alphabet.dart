import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/Alphabetssound/Alphasound.dart';
import 'package:kids/utils/admob.dart';
import 'package:kids/utils/model.dart';

class Alphabet extends StatefulWidget {
  @override
  State<Alphabet> createState() => _AlphabetState();
}

List<Numbermodel> kidslist = KidsList1();

class _AlphabetState extends State<Alphabet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.orange[50],
        title: Center(
            child: Text(
          'Alphabet',
          style: TextStyle(color: Colors.black, fontFamily: "arlrdbd"),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          child: GridView.builder(
            itemCount: kidslist.length,
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
                  print(kidslist);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlphaSound(index),
                      ));
                },
                child: Card(
                    color: Color(0xFFFEF9E4),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    shadowColor: Colors.redAccent,
                    child: Center(
                      child: Image.asset(
                        kidslist[index].image!,
                        height: 120,
                      ),
                    )),
              );
            },
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: MediaQuery.of(context).size.width *0.13,
      //   width: 25,
      //   child: AdWidget(
      //     // ad:AdmobHelper.getBannerAd()..load(),
      //   ),
      // ),
    );
  }
}
