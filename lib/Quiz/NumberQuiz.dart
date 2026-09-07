import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

List<Numbermodel> NumberQuizList = NumberQuiz();

class Numberquiz extends StatelessWidget {
  const Numberquiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Number Quiz',
      items: NumberQuizList,
      questions: numberquestion,
      accent: KidsTheme.number,
    );
  }
}
