import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

List<Numbermodel> animallist = ANIMAL1();

class AnimalQuiz extends StatelessWidget {
  const AnimalQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Animal Quiz',
      items: animallist,
      questions: animalquestion,
      accent: KidsTheme.animal,
    );
  }
}
