import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

/// Spoken animal names for the listen-and-guess round, one per question.
List<Numbermodel> animallist = ANIMAL1();

/// "Hear the animal, tap its picture."
class AnimalsSong extends StatelessWidget {
  const AnimalsSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Animal',
      items: animallist,
      questions: animalsongs2,
      accent: KidsTheme.animal,
      listenMode: true,
    );
  }
}
