import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

/// Spoken bird names for the listen-and-guess round, one per question.
List<Numbermodel> bridslist = BRIDS1();

/// "Hear the bird, tap its picture."
class BirdsSong extends StatelessWidget {
  const BirdsSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Bird',
      items: bridslist,
      questions: birdsongs2,
      accent: KidsTheme.bird,
      listenMode: true,
    );
  }
}
