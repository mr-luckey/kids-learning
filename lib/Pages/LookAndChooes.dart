import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/Quiz/ABCQuize.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_card.dart';
import 'package:kids/Quiz/AnimalQuize.dart';
import 'package:kids/Quiz/BirdQuize.dart';
import 'package:kids/Quiz/ColorQuiz.dart';
import 'package:kids/Quiz/FlowerQuize.dart';
import 'package:kids/Quiz/FruitQuize.dart';
import 'package:kids/Quiz/MonthQuize.dart';
import 'package:kids/Quiz/NumberQuiz.dart';
import 'package:kids/Quiz/ShapeQuiz.dart';
import 'package:kids/Quiz/VegitableQuiz.dart';
// import 'package:kids/utils/admob.dart';
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
                        text: 'Look And Choose',
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
