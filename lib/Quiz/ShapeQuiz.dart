import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

List<Numbermodel> shapelist = SHAPE1();

class Shapequiz extends StatelessWidget {
  const Shapequiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Shape Quiz',
      items: shapelist,
      questions: shapequestion,
      accent: KidsTheme.shape,
    );
  }
}
