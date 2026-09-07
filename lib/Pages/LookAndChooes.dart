import 'package:flutter/material.dart';
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
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// One row of the quiz menu.
class _QuizEntry {
  final String title;
  final String image;
  final Color color;

  /// Built lazily so opening this screen does not construct all ten quizzes.
  final Widget Function() build;

  const _QuizEntry({
    required this.title,
    required this.image,
    required this.color,
    required this.build,
  });
}

/// Quiz menu: a scrolling list of horizontal category pills, one per quiz.
class LookAndChooes extends StatelessWidget {
  final int index;

  LookAndChooes(this.index, {Key? key}) : super(key: key);

  final List<_QuizEntry> quizzes = <_QuizEntry>[
    _QuizEntry(
      title: 'ABC Songs',
      image: 'assets/images/Alphabet.png',
      color: KidsTheme.alphabet,
      build: () => ABCQuiz(),
    ),
    _QuizEntry(
      title: 'Number Songs',
      image: 'assets/images/Numbers.png',
      color: KidsTheme.number,
      build: () => const Numberquiz(),
    ),
    _QuizEntry(
      title: 'Color Songs',
      image: 'assets/images/Color.png',
      color: KidsTheme.color,
      build: () => const Colorquiz(),
    ),
    _QuizEntry(
      title: 'Shape Songs',
      image: 'assets/images/Shapes.png',
      color: KidsTheme.shape,
      build: () => const Shapequiz(),
    ),
    _QuizEntry(
      title: 'Animal Songs',
      image: 'assets/images/Animals.png',
      color: KidsTheme.animal,
      build: () => const AnimalQuiz(),
    ),
    _QuizEntry(
      title: 'Bird Songs',
      image: 'assets/images/Birds.png',
      color: KidsTheme.bird,
      build: () => const Birdquiz(),
    ),
    _QuizEntry(
      title: 'Flower Songs',
      image: 'assets/images/Flowers.png',
      color: KidsTheme.flower,
      build: () => const Flowerquiz(),
    ),
    _QuizEntry(
      title: 'Fruit Songs',
      image: 'assets/images/Fruit.png',
      color: KidsTheme.fruits,
      build: () => const Fruitquiz(),
    ),
    _QuizEntry(
      title: 'Month Songs',
      image: 'assets/images/Month.png',
      color: KidsTheme.navOrange,
      build: () => const Monthquiz(),
    ),
    _QuizEntry(
      title: 'Vegetable Songs',
      image: 'assets/images/Vegitable.png',
      color: KidsTheme.tileStartLearning,
      build: () => const Vegitablequiz(),
    ),
  ];

  void _open(BuildContext context, _QuizEntry entry) {
    KidsSound.instance.whoosh();
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
                  itemCount: quizzes.length,
                  itemBuilder: (BuildContext context, int index) {
                    final _QuizEntry entry = quizzes[index];
                    return KidsPopIn(
                      delay: Duration(milliseconds: 60 * index),
                      child: KidsCategoryPill(
                        label: entry.title,
                        borderColor: entry.color,
                        imageAsset: entry.image,
                        bounce: true,
                        bounceDelay: Duration(milliseconds: 50 * index),
                        onTap: () => _open(context, entry),
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
                'Look And Choose',
                fontSize: 30,
                maxLines: 2,
                rimColor: Colors.white,
                fillColor: KidsTheme.tileLookChoose,
              ),
            ),
          ),
          KidsBounce(
            offset: 8,
            tilt: 0.05,
            child: Image.asset(
              'assets/images/Alphabet.png',
              width: 58,
              height: 58,
              fit: BoxFit.contain,
              errorBuilder: (BuildContext c, Object e, StackTrace? s) {
                return const Icon(
                  Icons.quiz_rounded,
                  size: 50,
                  color: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
