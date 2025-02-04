import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/Quiz/ABCQuize.dart';
import 'package:kids/Quiz/AnimalQuize.dart';
import 'package:kids/Quiz/BirdQuize.dart';
import 'package:kids/Quiz/ColorQuiz.dart';
import 'package:kids/Quiz/FlowerQuize.dart';
import 'package:kids/Quiz/FruitQuize.dart';
import 'package:kids/Quiz/MonthQuize.dart';
import 'package:kids/Quiz/NumberQuiz.dart';
import 'package:kids/Quiz/ShapeQuiz.dart';
import 'package:kids/Quiz/VegitableQuiz.dart';
import 'package:kids/utils/admob.dart';
import 'package:kids/utils/app_constrant.dart';

class LookAndChooes extends StatelessWidget {
  final int index;
  LookAndChooes(this.index);

  // Define grid items structure
  final List<Map<String, dynamic>> gridItems = [
    {
      'title': 'ABC Songs',
      'image': 'assets/images/Alphabet.png',
      'route': ABCQuiz(),
    },
    {
      'title': 'Number Songs',
      'image': 'assets/images/Numbers.png',
      'route': Numberquiz(),
    },
    {
      'title': 'Color Songs',
      'image': 'assets/images/Color.png',
      'route': Colorquiz(),
    },
    {
      'title': 'Shape Songs',
      'image': 'assets/images/Shapes.png',
      'route': Shapequiz(),
    },
    {
      'title': 'Animal Songs',
      'image': 'assets/images/Animals.png',
      'route': AnimalQuiz(),
    },
    {
      'title': 'Bird Songs',
      'image': 'assets/images/Birds.png',
      'route': Birdquiz(),
    },
    {
      'title': 'Flower Songs',
      'image': 'assets/images/Flowers.png',
      'route': Flowerquiz(),
    },
    {
      'title': 'Fruit Songs',
      'image': 'assets/images/Fruit.png',
      'route': Fruitquiz(),
    },
    {
      'title': 'Month Songs',
      'image': 'assets/images/Month.png',
      'route': Monthquiz(),
    },
    {
      'title': 'Vegetable Songs',
      'image': 'assets/images/Vegitable.png',
      'route': Vegitablequiz(),
    },
  ];

  // Reusable grid item widget
  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      // splashColor: Colors.orange[100],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item['route']),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: LookAndChooesbgcolor,
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
                    color: LookAndChooestextcolor,
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
          color: LookAndChooestextcolor,
        ),
        backgroundColor: LookAndChooesbgcolor,
        elevation: 0,
        title: const Center(
          child: Text(
            'Look And Chooes',
            style: TextStyle(
              color: LookAndChooestextcolor,
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
