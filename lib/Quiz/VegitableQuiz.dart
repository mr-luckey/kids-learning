import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

List<Numbermodel> vegitablelist = vegitable1();

class Vegitablequiz extends StatelessWidget {
  const Vegitablequiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Vegetable Quiz',
      items: vegitablelist,
      questions: vegitablequestion,
      accent: KidsTheme.tileStartLearning,
    );
  }
}
