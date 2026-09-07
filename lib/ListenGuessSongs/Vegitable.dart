import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

/// Spoken vegetable names for the listen-and-guess round, one per question.
List<Numbermodel> vegitablelist = vegitable1();

/// "Hear the vegetable, tap its picture."
class VegitableSong extends StatelessWidget {
  const VegitableSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Vegetable',
      items: vegitablelist,
      questions: vegitablesongs2,
      accent: KidsTheme.tileStartLearning,
      listenMode: true,
    );
  }
}
