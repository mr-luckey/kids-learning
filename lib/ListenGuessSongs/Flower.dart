import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

/// Spoken flower names for the listen-and-guess round, one per question.
List<Numbermodel> flowerlist = FLOWERS1();

/// "Hear the flower, tap its picture."
class FlowerSong extends StatelessWidget {
  const FlowerSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Flower',
      items: flowerlist,
      questions: flowerssongs2,
      accent: KidsTheme.flower,
      listenMode: true,
    );
  }
}
