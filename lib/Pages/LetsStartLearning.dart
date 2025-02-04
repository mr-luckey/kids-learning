import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids/Learning/Alphabet.dart';
import 'package:kids/Learning/Animals.dart';
import 'package:kids/Learning/Brids.dart';
import 'package:kids/Learning/Colors.dart' as learning_colors;
import 'package:kids/Learning/Flowers.dart';
import 'package:kids/Learning/Fruit.dart';
import 'package:kids/Learning/Month.dart';
import 'package:kids/Learning/Number.dart';
import 'package:kids/Learning/Shapes.dart';
import 'package:kids/Learning/Vegitable.dart';
// import 'package:kids/utils/admob.dart';

// ignore: must_be_immutable
class LetsStartLearning extends StatelessWidget {
  // int index;
  LetsStartLearning({Key? key}) : super(key: key);

  // Define grid items structure
  final List<Map<String, dynamic>> gridItems = [
    {
      'title': 'Alphabet',
      'image': 'assets/images/number.png',
      'route': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Alphabet())),
    },
    {
      'title': 'Number',
      'image': 'assets/images/Numbers.png',
      'route': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Numbers())),
    },
    {
      'title': 'Color',
      'image': 'assets/images/Color.png',
      'route': (context) => Get.to(() => learning_colors.Color()),
    },
    {
      'title': 'Shape',
      'image': 'assets/images/Shapes.png',
      'route': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Shapes())),
    },
    {
      'title': 'Animal',
      'image': 'assets/images/Animals.png',
      'route': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Animal())),
    },
    {
      'title': 'Bird',
      'image': 'assets/images/Birds.png',
      'route': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Brids())),
    },
    {
      'title': 'Flower',
      'image': 'assets/images/Flowers.png',
      'route': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Flower())),
    },
    {
      'title': 'Fruit',
      'image': 'assets/images/Fruit.png',
      'route': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Fruits())),
    },
    {
      'title': 'Month',
      'image': 'assets/images/Month.png',
      'route': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Month())),
    },
    {
      'title': 'Vegetable',
      'image': 'assets/images/Vegitable.png',
      'route': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Vegitable())),
    },
  ];

  // Reusable grid item widget
  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () => item['route'](context),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 220, 255, 228),
          borderRadius: BorderRadius.circular(10.0),
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
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  item['title'],
                  style: const TextStyle(
                    color: Color.fromARGB(255, 5, 174, 41),
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
          color: Color.fromARGB(255, 5, 174, 41),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 255, 228),
        elevation: 0,
        title: const Text(
          "PreSchool Kids Learning",
          style: TextStyle(
            color: Color.fromARGB(255, 5, 174, 41),
            fontFamily: "arlrdbd",
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
      //     // ad: AdmobHelper.getBannerAd()..load(),
      //   ),
      // ),
    );
  }
}
