import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

List<Numbermodel> FRUITlist = fruit1();

class Fruitquiz extends StatelessWidget {
  const Fruitquiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Fruit Quiz',
      items: FRUITlist,
      questions: fruitquestion,
      accent: KidsTheme.fruits,
    );
  }
}
