import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

/// Spoken numbers for the listen-and-guess round, one per question.
List<Numbermodel> numbersongs1 = numbersongs();

/// "Hear the number, tap the digit."
class NumberSong extends StatelessWidget {
  const NumberSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Number',
      items: numbersongs1,
      questions: numbersongs2,
      accent: KidsTheme.number,
      listenMode: true,
    );
  }
}
