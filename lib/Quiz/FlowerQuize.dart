import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

List<Numbermodel> flowerlist = FLOWERS1();

class Flowerquiz extends StatelessWidget {
  const Flowerquiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Flower Quiz',
      items: flowerlist,
      questions: flowerquestion,
      accent: KidsTheme.flower,
    );
  }
}
