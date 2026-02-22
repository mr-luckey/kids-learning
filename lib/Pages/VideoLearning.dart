import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/VideoLearning/ABC%20song.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_card.dart';
import 'package:kids/VideoLearning/AnimalVideo.dart';
import 'package:kids/VideoLearning/BirdVideo.dart';
import 'package:kids/VideoLearning/FlowerVideo.dart';
import 'package:kids/VideoLearning/FruitVideo.dart';
import 'package:kids/VideoLearning/MonthVideo.dart';
import 'package:kids/VideoLearning/Number%20video.dart';
import 'package:kids/VideoLearning/ShapeVideo.dart';
import 'package:kids/VideoLearning/VegitableVideo.dart';
import 'package:kids/VideoLearning/colorvideo.dart';
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

  static const List<List<Color>> _cardGradients = [
    [Color(0xFFB8E6F5), Color(0xFFFFE5A8)],
    [Color(0xFFFFB5D0), Color(0xFFFFE5A8)],
    [Color(0xFFA8E6A0), Color(0xFFB8D4F0)],
    [Color(0xFFFFE5A8), Color(0xFFB8E6F5)],
    [Color(0xFFD4C5F9), Color(0xFFB5EAD7)],
    [Color(0xFFB5EAD7), Color(0xFF92EFA6)],
    [Color(0xFFFFE5D9), Color(0xFFFFB5A7)],
    [Color(0xFFFFF9E3), Color(0xFFFFDAB9)],
    [Color(0xFFB5EAD7), Color(0xFFA8E6CF)],
    [Color(0xFFE8E0F0), Color(0xFFB5EAD7)],
  ];

  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item, int index) {
    final gradient = _cardGradients[index % _cardGradients.length];
    return AdventureCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item['route']),
        );
      },
      gradientColors: gradient,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(item['image'], height: 72),
            const SizedBox(height: 8),
            AdventureText(text: item['title'], fontSize: 13),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdventureBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: const Color(0xFF1A5F7A),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: AdventureTitle(
                        text: 'Video Learning',
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.88,
                  ),
                  itemCount: gridItems.length,
                  itemBuilder: (context, index) =>
                      _buildGridItem(context, gridItems[index], index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
