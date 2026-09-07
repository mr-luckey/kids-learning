import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

List<Numbermodel> colorlist = COLOR1();

class Colorquiz extends StatelessWidget {
  const Colorquiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Color Quiz',
      items: colorlist,
      questions: colorquestion,
      accent: KidsTheme.color,
    );
  }
}
