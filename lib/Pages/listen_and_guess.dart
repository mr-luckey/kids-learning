import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/ListenGuessSongs/Alphabet.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_card.dart';
import 'package:kids/ListenGuessSongs/Animal.dart';
import 'package:kids/ListenGuessSongs/Brid.dart';
import 'package:kids/ListenGuessSongs/Color.dart';
import 'package:kids/ListenGuessSongs/Flower.dart';
import 'package:kids/ListenGuessSongs/Fruit.dart';
import 'package:kids/ListenGuessSongs/Month.dart';
import 'package:kids/ListenGuessSongs/Number.dart';
import 'package:kids/ListenGuessSongs/Shapes.dart';
import 'package:kids/ListenGuessSongs/Vegitable.dart';
// import 'package:kids/utils/admob.dart';
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
        flutterTts.speak(item['speak']);
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
            AdventureText(text: item['title'], fontSize: 14),
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
                        text: 'Listen And Guess',
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
