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
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// One row of the main menu.
class _Category {
  final String title;
  final String image;
  final Color color;
  final void Function(BuildContext context) open;

  const _Category({
    required this.title,
    required this.image,
    required this.color,
    required this.open,
  });
}

/// Main menu: a scrolling list of horizontal category pills, one per lesson
/// set, each in its own accent colour.
class LetsStartLearning extends StatelessWidget {
  LetsStartLearning({Key? key}) : super(key: key);

  static void _push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => page),
    );
  }

  final List<_Category> categories = <_Category>[
    _Category(
      title: 'Alphabet',
      image: 'assets/images/Alphabet.png',
      color: KidsTheme.alphabet,
      open: (BuildContext context) => _push(context, Alphabet()),
    ),
    _Category(
      title: 'Number',
      image: 'assets/images/Numbers.png',
      color: KidsTheme.number,
      open: (BuildContext context) => _push(context, Numbers()),
    ),
    _Category(
      title: 'Color',
      image: 'assets/images/Color.png',
      color: KidsTheme.color,
      open: (BuildContext context) => Get.to(() => learning_colors.Color()),
    ),
    _Category(
      title: 'Shape',
      image: 'assets/images/Shapes.png',
      color: KidsTheme.shape,
      open: (BuildContext context) => _push(context, Shapes()),
    ),
    _Category(
      title: 'Animal',
      image: 'assets/images/Animals.png',
      color: KidsTheme.animal,
      open: (BuildContext context) => _push(context, Animal()),
    ),
    _Category(
      title: 'Bird',
      image: 'assets/images/Birds.png',
      color: KidsTheme.bird,
      open: (BuildContext context) => _push(context, Brids()),
    ),
    _Category(
      title: 'Flower',
      image: 'assets/images/Flowers.png',
      color: KidsTheme.flower,
      open: (BuildContext context) => _push(context, Flower()),
    ),
    _Category(
      title: 'Fruit',
      image: 'assets/images/Fruit.png',
      color: KidsTheme.fruits,
      open: (BuildContext context) => _push(context, Fruits()),
    ),
    _Category(
      title: 'Month',
      image: 'assets/images/Month.png',
      color: KidsTheme.navOrange,
      open: (BuildContext context) => _push(context, Month()),
    ),
    _Category(
      title: 'Vegetable',
      image: 'assets/images/Vegitable.png',
      color: KidsTheme.tileStartLearning,
      open: (BuildContext context) => _push(context, Vegitable()),
    ),
  ];

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
                    final _Category category = categories[index];
                    return KidsPopIn(
                      delay: Duration(milliseconds: 60 * index),
                      child: KidsCategoryPill(
                        label: category.title,
                        borderColor: category.color,
                        imageAsset: category.image,
                        bounce: true,
                        bounceDelay: Duration(milliseconds: 50 * index),
                        onTap: () {
                          KidsSound.instance.whoosh();
                          category.open(context);
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

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          KidsCircleNav.back(
            onTap: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: KidsBubbleTitle(
                'Preschool Kids\nLearning',
                fontSize: 30,
                maxLines: 2,
                rimColor: Colors.white,
                fillColor: KidsTheme.bubbleFillBlue,
              ),
            ),
          ),
          KidsBounce(
            offset: 8,
            tilt: 0.05,
            child: Image.asset(
              'assets/images/Animals.png',
              width: 58,
              height: 58,
              fit: BoxFit.contain,
              errorBuilder: (BuildContext c, Object e, StackTrace? s) {
                return const Icon(
                  Icons.pets_rounded,
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
