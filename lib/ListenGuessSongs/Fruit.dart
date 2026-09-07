import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

/// Spoken fruit names for the listen-and-guess round, one per question.
// ignore: non_constant_identifier_names
List<Numbermodel> FRUITlist = fruit1();

/// "Hear the fruit, tap its picture."
class FruitSong extends StatelessWidget {
  const FruitSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Fruit',
      items: FRUITlist,
      questions: fruitsongs2,
      accent: KidsTheme.fruits,
      listenMode: true,
    );
  }
}
