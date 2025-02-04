import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/ListenGuessSongs/Alphabet.dart';
import 'package:kids/ListenGuessSongs/Animal.dart';
import 'package:kids/ListenGuessSongs/Brid.dart';
import 'package:kids/ListenGuessSongs/Color.dart';
import 'package:kids/ListenGuessSongs/Flower.dart';
import 'package:kids/ListenGuessSongs/Fruit.dart';
import 'package:kids/ListenGuessSongs/Month.dart';
import 'package:kids/ListenGuessSongs/Number.dart';
import 'package:kids/ListenGuessSongs/Shapes.dart';
import 'package:kids/ListenGuessSongs/Vegitable.dart';
import 'package:kids/utils/admob.dart';
import 'package:kids/utils/app_constrant.dart';

class ListenGuess extends StatefulWidget {
  @override
  State<ListenGuess> createState() => _ListenGuessState();
}

class _ListenGuessState extends State<ListenGuess> {
  final FlutterTts flutterTts = FlutterTts();
  int index = 0;

  // Define grid items structure
  final List<Map<String, dynamic>> gridItems = [
    {
      'title': 'Alphabet',
      'image': 'assets/images/Alphabet.png',
      'route': AlphabetSong(),
      'speak': 'Apple',
    },
    {
      'title': 'Number',
      'image': 'assets/images/Numbers.png',
      'route': NumberSong(),
      'speak': 'Zero',
    },
    {
      'title': 'Color',
      'image': 'assets/images/Color.png',
      'route': ColorSong(),
      'speak': 'AQUA',
    },
    {
      'title': 'Shape',
      'image': 'assets/images/Shapes.png',
      'route': ShapesSong(),
      'speak': 'ARROW',
    },
    {
      'title': 'Animal',
      'image': 'assets/images/Animals.png',
      'route': AnimalsSong(),
      'speak': 'BEER',
    },
    {
      'title': 'Bird',
      'image': 'assets/images/Birds.png',
      'route': BirdsSong(),
      'speak': 'ARARAT',
    },
    {
      'title': 'Flower',
      'image': 'assets/images/Flowers.png',
      'route': FlowerSong(),
      'speak': 'BLACK ROSE',
    },
    {
      'title': 'Fruit',
      'image': 'assets/images/Fruit.png',
      'route': FruitSong(),
      'speak': 'APPLE',
    },
    {
      'title': 'Month',
      'image': 'assets/images/Month.png',
      'route': MonthSong(),
      'speak': 'JANUARY',
    },
    {
      'title': 'Vegetable',
      'image': 'assets/images/Vegitable.png',
      'route': VegitableSong(),
      'speak': 'BELL PEPPER',
    },
  ];

  // Reusable grid item widget
  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      // splashColor: Colors.orange[100],
      onTap: () {
        flutterTts.speak(item['speak']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item['route']),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: listenandgessbgcolor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              item['image'],
              height: 90,
            ),
            Container(
              height: 45,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.orange[100],
              ),
              child: Center(
                child: Text(
                  item['title'],
                  style: const TextStyle(
                    color: listenandgessTextcolor,
                    fontFamily: "arlrdbd",
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: listenandgessTextcolor,
        ),
        backgroundColor: listenandgessbgcolor,
        elevation: 0,
        title: const Center(
          child: Text(
            'Listen And Guess',
            style: TextStyle(
              color: listenandgessTextcolor,
              fontFamily: "arlrdbd",
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(35),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 20,
              ),
              itemCount: gridItems.length,
              itemBuilder: (context, index) =>
                  _buildGridItem(context, gridItems[index]),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: MediaQuery.of(context).size.width * 0.13,
      //   width: 25,
      //   child: AdWidget(
      //     ad: AdmobHelper.getBannerAd()..load(),
      //   ),
      // ),
    );
  }
}
