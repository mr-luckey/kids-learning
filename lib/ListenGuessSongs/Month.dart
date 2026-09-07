import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

/// Spoken month names for the listen-and-guess round, one per question.
List<Numbermodel> monthlist = month1();

/// "Hear the month, tap its picture."
class MonthSong extends StatelessWidget {
  const MonthSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Month',
      items: monthlist,
      questions: monthsongs2,
      accent: KidsTheme.navOrange,
      listenMode: true,
    );
  }
}
