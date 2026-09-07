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
import 'package:kids/utils/ad_helper.dart';
import 'package:kids/utils/banner_ad_widget.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_engaging_card.dart';
import 'package:kids/widgets/kids_sky_background.dart';

class _GuessEntry {
  final String title;
  final String image;
  final Color color;
  final String speak;
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
      image: 'assets/ui/cat_Alphabet.png',
      color: KidsTheme.alphabet,
      speak: 'Apple',
      build: () => AlphabetSong(),
    ),
    _GuessEntry(
      title: 'Number',
      image: 'assets/ui/cat_Numbers.png',
      color: KidsTheme.number,
      speak: 'Zero',
      build: () => NumberSong(),
    ),
    _GuessEntry(
      title: 'Color',
      image: 'assets/ui/cat_Color.png',
      color: KidsTheme.color,
      speak: 'AQUA',
      build: () => ColorSong(),
    ),
    _GuessEntry(
      title: 'Shape',
      image: 'assets/ui/cat_Shapes.png',
      color: KidsTheme.shape,
      speak: 'ARROW',
      build: () => ShapesSong(),
    ),
    _GuessEntry(
      title: 'Animal',
      image: 'assets/ui/cat_Animals.png',
      color: KidsTheme.animal,
      speak: 'Lion',
      build: () => AnimalsSong(),
    ),
    _GuessEntry(
      title: 'Bird',
      image: 'assets/ui/cat_Birds.png',
      color: KidsTheme.bird,
      speak: 'Parrot',
      build: () => BirdsSong(),
    ),
    _GuessEntry(
      title: 'Flower',
      image: 'assets/ui/cat_Flowers.png',
      color: KidsTheme.flower,
      speak: 'Rose',
      build: () => FlowerSong(),
    ),
    _GuessEntry(
      title: 'Fruit',
      image: 'assets/ui/cat_Fruit.png',
      color: KidsTheme.fruits,
      speak: 'Apple',
      build: () => FruitSong(),
    ),
    _GuessEntry(
      title: 'Month',
      image: 'assets/ui/cat_Month.png',
      color: KidsTheme.navOrange,
      speak: 'January',
      build: () => MonthSong(),
    ),
    _GuessEntry(
      title: 'Vegetable',
      image: 'assets/ui/cat_Vegitable.png',
      color: KidsTheme.tileStartLearning,
      speak: 'Carrot',
      build: () => VegitableSong(),
    ),
  ];

  Future<void> _open(_GuessEntry entry) async {
    KidsSound.instance.whoosh();
    try {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setVolume(1.0);
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.speak(entry.speak);
    } catch (_) {}
    if (!mounted) return;
    AdManager().showInterstitial(placement: 'category_open');
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => entry.build()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KidsTheme.skyTop,
      bottomNavigationBar: const BannerAdWidget(placement: 'quiz'),
      body: KidsSkyBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              KidsHubHeader(
                title: 'Listen and Guess',
                onBack: () {
                  KidsSound.instance.whoosh();
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 20),
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (BuildContext context, int i) {
                    final _GuessEntry entry = categories[i];
                    return KidsPopIn(
                      delay: Duration(milliseconds: 50 * i),
                      child: KidsEngagingCard(
                        label: entry.title,
                        color: entry.color,
                        imageAsset: entry.image,
                        bounceDelay: Duration(milliseconds: 80 * i),
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
}
