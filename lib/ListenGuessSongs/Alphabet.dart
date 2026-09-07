import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

/// Spoken words for the alphabet round, one per question.
List<Numbermodel> abcsongs1 = abcsongs();

/// "Hear the word, tap the letter it starts with."
class AlphabetSong extends StatelessWidget {
  const AlphabetSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Alphabet',
      items: abcsongs1,
      questions: alphasongs2,
      accent: KidsTheme.alphabet,
      listenMode: true,
    );
  }
}
