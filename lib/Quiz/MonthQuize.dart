import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

List<Numbermodel> monthlist = month1();

class Monthquiz extends StatelessWidget {
  const Monthquiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Month Quiz',
      items: monthlist,
      questions: monthquestion,
      accent: KidsTheme.navOrange,
    );
  }
}
