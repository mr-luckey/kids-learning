import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// One row of the listen-and-guess menu.
class _GuessEntry {
  final String title;
  final String image;
  final Color color;

  /// Word spoken by TTS when the row is tapped, previewing the category.
  final String speak;

  /// Built lazily so opening this screen does not construct all ten songs.
  final Widget Function() build;

  const _GuessEntry({
    required this.title,
    required this.image,
    required this.color,
    required this.speak,
    required this.build,
  });
}

class ListenGuess extends StatefulWidget {
  const ListenGuess({Key? key}) : super(key: key);

  @override
  State<ListenGuess> createState() => _ListenGuessState();
}

class _ListenGuessState extends State<ListenGuess> {
  final FlutterTts flutterTts = FlutterTts();

  final List<_GuessEntry> categories = <_GuessEntry>[
    _GuessEntry(
      title: 'Alphabet',
      image: 'assets/images/Alphabet.png',
      color: KidsTheme.alphabet,
      speak: 'Apple',
      build: () => AlphabetSong(),
    ),
    _GuessEntry(
      title: 'Number',
      image: 'assets/images/Numbers.png',
      color: KidsTheme.number,
      speak: 'Zero',
      build: () => NumberSong(),
    ),
    _GuessEntry(
      title: 'Color',
      image: 'assets/images/Color.png',
      color: KidsTheme.color,
      speak: 'AQUA',
      build: () => ColorSong(),
    ),
    _GuessEntry(
      title: 'Shape',
      image: 'assets/images/Shapes.png',
      color: KidsTheme.shape,
      speak: 'ARROW',
      build: () => ShapesSong(),
    ),
    _GuessEntry(
      title: 'Animal',
      image: 'assets/images/Animals.png',
      color: KidsTheme.animal,
      speak: 'BEER',
      build: () => AnimalsSong(),
    ),
    _GuessEntry(
      title: 'Bird',
      image: 'assets/images/Birds.png',
      color: KidsTheme.bird,
      speak: 'ARARAT',
      build: () => BirdsSong(),
    ),
    _GuessEntry(
      title: 'Flower',
      image: 'assets/images/Flowers.png',
      color: KidsTheme.flower,
      speak: 'BLACK ROSE',
      build: () => FlowerSong(),
    ),
    _GuessEntry(
      title: 'Fruit',
      image: 'assets/images/Fruit.png',
      color: KidsTheme.fruits,
      speak: 'APPLE',
      build: () => FruitSong(),
    ),
    _GuessEntry(
      title: 'Month',
      image: 'assets/images/Month.png',
      color: KidsTheme.navOrange,
      speak: 'JANUARY',
      build: () => MonthSong(),
    ),
    _GuessEntry(
      title: 'Vegetable',
      image: 'assets/images/Vegitable.png',
      color: KidsTheme.tileStartLearning,
      speak: 'BELL PEPPER',
      build: () => VegitableSong(),
    ),
  ];

  void _open(_GuessEntry entry) {
    KidsSound.instance.whoosh();
    flutterTts.speak(entry.speak);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => entry.build(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KidsTheme.skyTop,
      body: KidsSkyBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _header(context),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 22),
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    final _GuessEntry entry = categories[index];
                    return KidsPopIn(
                      delay: Duration(milliseconds: 60 * index),
                      child: KidsCategoryPill(
                        label: entry.title,
                        borderColor: entry.color,
                        imageAsset: entry.image,
                        bounce: true,
                        bounceDelay: Duration(milliseconds: 50 * index),
                        onTap: () => _open(entry),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          KidsCircleNav.back(onTap: () => Navigator.of(context).pop()),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: KidsBubbleTitle(
                'Listen and Guess',
                fontSize: 30,
                maxLines: 2,
                rimColor: Colors.white,
                fillColor: KidsTheme.tileListenGuess,
              ),
            ),
          ),
          KidsSpeakerButton(
            size: 58,
            onTap: () => flutterTts.speak('Listen and Guess'),
          ),
        ],
      ),
    );
  }
}
