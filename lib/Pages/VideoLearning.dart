import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/VideoLearning/ABC%20song.dart';
import 'package:kids/VideoLearning/AnimalVideo.dart';
import 'package:kids/VideoLearning/BirdVideo.dart';
import 'package:kids/VideoLearning/FlowerVideo.dart';
import 'package:kids/VideoLearning/FruitVideo.dart';
import 'package:kids/VideoLearning/MonthVideo.dart';
import 'package:kids/VideoLearning/Number%20video.dart';
import 'package:kids/VideoLearning/ShapeVideo.dart';
import 'package:kids/VideoLearning/VegitableVideo.dart';
import 'package:kids/VideoLearning/colorvideo.dart';
import 'package:kids/utils/admob.dart';
import 'package:kids/utils/app_constrant.dart';

class VideoLearning extends StatefulWidget {
  @override
  State<VideoLearning> createState() => _VideoLearningState();
}

class _VideoLearningState extends State<VideoLearning> {
  // Define grid items structure
  final List<Map<String, dynamic>> gridItems = [
    {
      'title': 'ABC Video',
      'image': 'assets/images/Alphabet.png',
      'route': ABCVideo(),
    },
    {
      'title': 'Number Video',
      'image': 'assets/images/Numbers.png',
      'route': NumberVideo(),
    },
    {
      'title': 'Color Video',
      'image': 'assets/images/Color.png',
      'route': ColorVideo(),
    },
    {
      'title': 'Shape Video',
      'image': 'assets/images/Shapes.png',
      'route': ShapeVideo(),
    },
    {
      'title': 'Animal Video',
      'image': 'assets/images/Animals.png',
      'route': AnimalVideo(),
    },
    {
      'title': 'Bird Video',
      'image': 'assets/images/Birds.png',
      'route': BirdVideo(),
    },
    {
      'title': 'Flower Video',
      'image': 'assets/images/Flowers.png',
      'route': FlowerVideo(),
    },
    {
      'title': 'Fruit Video',
      'image': 'assets/images/Fruit.png',
      'route': FruitVideo(),
    },
    {
      'title': 'Month Video',
      'image': 'assets/images/Month.png',
      'route': MonthVideo(),
    },
    {
      'title': 'Vegetable Video',
      'image': 'assets/images/Vegitable.png',
      'route': VegitableVideo(),
    },
  ];

  // Reusable grid item widget
  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item['route']),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: videolearnBGcolor,
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
              ),
              child: Center(
                child: Text(
                  item['title'],
                  style: const TextStyle(
                    color: videolearnTextColor,
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
          color: Colors.black,
        ),
        backgroundColor: videolearnBGcolor,
        title: const Center(
          child: Text(
            'Video Learning',
            style: TextStyle(
              color: videolearnTextColor,
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
    );
  }
}
