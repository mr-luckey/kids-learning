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
import 'package:kids/utils/ad_helper.dart';
import 'package:kids/utils/banner_ad_widget.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_engaging_card.dart';
import 'package:kids/widgets/kids_sky_background.dart';

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

class LetsStartLearning extends StatelessWidget {
  LetsStartLearning({Key? key}) : super(key: key);

  static void _push(BuildContext context, Widget page) {
    AdManager().showInterstitial();
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => page),
    );
  }

  final List<_Category> categories = <_Category>[
    _Category(
      title: 'Alphabet',
      image: 'assets/ui/cat_Alphabet.png',
      color: KidsTheme.alphabet,
      open: (BuildContext context) => _push(context, Alphabet()),
    ),
    _Category(
      title: 'Number',
      image: 'assets/ui/cat_Numbers.png',
      color: KidsTheme.number,
      open: (BuildContext context) => _push(context, Numbers()),
    ),
    _Category(
      title: 'Color',
      image: 'assets/ui/cat_Color.png',
      color: KidsTheme.color,
      open: (BuildContext context) {
        AdManager().showInterstitial();
        Get.to(() => learning_colors.Color());
      },
    ),
    _Category(
      title: 'Shape',
      image: 'assets/ui/cat_Shapes.png',
      color: KidsTheme.shape,
      open: (BuildContext context) => _push(context, Shapes()),
    ),
    _Category(
      title: 'Animal',
      image: 'assets/ui/cat_Animals.png',
      color: KidsTheme.animal,
      open: (BuildContext context) => _push(context, Animal()),
    ),
    _Category(
      title: 'Bird',
      image: 'assets/ui/cat_Birds.png',
      color: KidsTheme.bird,
      open: (BuildContext context) => _push(context, Brids()),
    ),
    _Category(
      title: 'Flower',
      image: 'assets/ui/cat_Flowers.png',
      color: KidsTheme.flower,
      open: (BuildContext context) => _push(context, Flower()),
    ),
    _Category(
      title: 'Fruit',
      image: 'assets/ui/cat_Fruit.png',
      color: KidsTheme.fruits,
      open: (BuildContext context) => _push(context, Fruits()),
    ),
    _Category(
      title: 'Month',
      image: 'assets/ui/cat_Month.png',
      color: KidsTheme.navOrange,
      open: (BuildContext context) => _push(context, Month()),
    ),
    _Category(
      title: 'Vegetable',
      image: 'assets/ui/cat_Vegitable.png',
      color: KidsTheme.tileStartLearning,
      open: (BuildContext context) => _push(context, Vegitable()),
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
                title: 'Preschool Kids\nLearning',
                onBack: () {
                  KidsSound.instance.whoosh();
                  Navigator.of(context).pop();
                },
                trailing: KidsBounce(
                  offset: 7,
                  child: Image.asset(
                    'assets/ui/letter_A.png',
                    width: 54,
                    height: 54,
                    filterQuality: FilterQuality.high,
                  ),
                ),
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
                  itemBuilder: (BuildContext context, int index) {
                    final _Category category = categories[index];
                    return KidsPopIn(
                      delay: Duration(milliseconds: 50 * index),
                      child: KidsEngagingCard(
                        label: category.title,
                        color: category.color,
                        imageAsset: category.image,
                        bounceDelay: Duration(milliseconds: 80 * index),
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
}
