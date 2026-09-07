import 'package:flutter/material.dart';
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
import 'package:kids/utils/ad_helper.dart';
import 'package:kids/utils/banner_ad_widget.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// One row of the video menu.
class _VideoEntry {
  final String title;
  final String image;
  final Color color;

  /// Built lazily so opening this screen does not construct all ten players.
  final Widget Function() build;

  const _VideoEntry({
    required this.title,
    required this.image,
    required this.color,
    required this.build,
  });
}

class VideoLearning extends StatefulWidget {
  const VideoLearning({Key? key}) : super(key: key);

  @override
  State<VideoLearning> createState() => _VideoLearningState();
}

class _VideoLearningState extends State<VideoLearning> {
  final List<_VideoEntry> videos = <_VideoEntry>[
    _VideoEntry(
      title: 'ABC Video',
      image: 'assets/images/Alphabet.png',
      color: KidsTheme.alphabet,
      build: () => ABCVideo(),
    ),
    _VideoEntry(
      title: 'Number Video',
      image: 'assets/images/Numbers.png',
      color: KidsTheme.number,
      build: () => NumberVideo(),
    ),
    _VideoEntry(
      title: 'Color Video',
      image: 'assets/images/Color.png',
      color: KidsTheme.color,
      build: () => ColorVideo(),
    ),
    _VideoEntry(
      title: 'Shape Video',
      image: 'assets/images/Shapes.png',
      color: KidsTheme.shape,
      build: () => ShapeVideo(),
    ),
    _VideoEntry(
      title: 'Animal Video',
      image: 'assets/images/Animals.png',
      color: KidsTheme.animal,
      build: () => AnimalVideo(),
    ),
    _VideoEntry(
      title: 'Bird Video',
      image: 'assets/images/Birds.png',
      color: KidsTheme.bird,
      build: () => BirdVideo(),
    ),
    _VideoEntry(
      title: 'Flower Video',
      image: 'assets/images/Flowers.png',
      color: KidsTheme.flower,
      build: () => FlowerVideo(),
    ),
    _VideoEntry(
      title: 'Fruit Video',
      image: 'assets/images/Fruit.png',
      color: KidsTheme.fruits,
      build: () => FruitVideo(),
    ),
    _VideoEntry(
      title: 'Month Video',
      image: 'assets/images/Month.png',
      color: KidsTheme.navOrange,
      build: () => MonthVideo(),
    ),
    _VideoEntry(
      title: 'Vegetable Video',
      image: 'assets/images/Vegitable.png',
      color: KidsTheme.tileStartLearning,
      build: () => VegitableVideo(),
    ),
  ];

  void _open(_VideoEntry entry) {
    KidsSound.instance.whoosh();
    AdManager().showInterstitial(placement: 'after_video');
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
      bottomNavigationBar: const BannerAdWidget(placement: 'video'),
      body: KidsSkyBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _header(context),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 22),
                  itemCount: videos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final _VideoEntry entry = videos[index];
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
                'Video Learning',
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
            child: const Icon(
              Icons.play_circle_fill_rounded,
              size: 54,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
