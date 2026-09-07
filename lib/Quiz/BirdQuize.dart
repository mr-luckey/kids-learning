import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

List<Numbermodel> bridslist = BRIDS1();

class Birdquiz extends StatelessWidget {
  const Birdquiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Bird Quiz',
      items: bridslist,
      questions: birdquestion,
      accent: KidsTheme.bird,
    );
  }
}
