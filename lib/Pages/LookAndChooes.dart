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
import 'package:kids/utils/ad_helper.dart';
import 'package:kids/utils/banner_ad_widget.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_engaging_card.dart';
import 'package:kids/widgets/kids_sky_background.dart';

class _QuizEntry {
  final String title;
  final String image;
  final Color color;
  final Widget Function() build;

  const _QuizEntry({
    required this.title,
    required this.image,
    required this.color,
    required this.build,
  });
}

class LookAndChooes extends StatelessWidget {
  final int index;

  LookAndChooes(this.index, {Key? key}) : super(key: key);

  final List<_QuizEntry> quizzes = <_QuizEntry>[
    _QuizEntry(
      title: 'ABC Quiz',
      image: 'assets/ui/cat_Alphabet.png',
      color: KidsTheme.alphabet,
      build: () => ABCQuiz(),
    ),
    _QuizEntry(
      title: 'Number Quiz',
      image: 'assets/ui/cat_Numbers.png',
      color: KidsTheme.number,
      build: () => const Numberquiz(),
    ),
    _QuizEntry(
      title: 'Color Quiz',
      image: 'assets/ui/cat_Color.png',
      color: KidsTheme.color,
      build: () => const Colorquiz(),
    ),
    _QuizEntry(
      title: 'Shape Quiz',
      image: 'assets/ui/cat_Shapes.png',
      color: KidsTheme.shape,
      build: () => const Shapequiz(),
    ),
    _QuizEntry(
      title: 'Animal Quiz',
      image: 'assets/ui/cat_Animals.png',
      color: KidsTheme.animal,
      build: () => const AnimalQuiz(),
    ),
    _QuizEntry(
      title: 'Bird Quiz',
      image: 'assets/ui/cat_Birds.png',
      color: KidsTheme.bird,
      build: () => const Birdquiz(),
    ),
    _QuizEntry(
      title: 'Flower Quiz',
      image: 'assets/ui/cat_Flowers.png',
      color: KidsTheme.flower,
      build: () => const Flowerquiz(),
    ),
    _QuizEntry(
      title: 'Fruit Quiz',
      image: 'assets/ui/cat_Fruit.png',
      color: KidsTheme.fruits,
      build: () => const Fruitquiz(),
    ),
    _QuizEntry(
      title: 'Month Quiz',
      image: 'assets/ui/cat_Month.png',
      color: KidsTheme.navOrange,
      build: () => const Monthquiz(),
    ),
    _QuizEntry(
      title: 'Vegetable Quiz',
      image: 'assets/ui/cat_Vegitable.png',
      color: KidsTheme.tileStartLearning,
      build: () => const Vegitablequiz(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KidsTheme.skyTop,
      bottomNavigationBar: const BannerAdWidget(),
      body: KidsSkyBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              KidsHubHeader(
                title: 'Look And Choose',
                onBack: () {
                  KidsSound.instance.whoosh();
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 20),
                  itemCount: quizzes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (BuildContext context, int i) {
                    final _QuizEntry q = quizzes[i];
                    return KidsPopIn(
                      delay: Duration(milliseconds: 50 * i),
                      child: KidsEngagingCard(
                        label: q.title,
                        color: q.color,
                        imageAsset: q.image,
                        bounceDelay: Duration(milliseconds: 80 * i),
                        onTap: () {
                          KidsSound.instance.whoosh();
                          AdManager().showInterstitial();
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => q.build(),
                            ),
                          );
                        },
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
