import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

/// Spoken shape names for the listen-and-guess round, one per question.
List<Numbermodel> shapelist = SHAPE1();

/// "Hear the shape, tap the picture."
class ShapesSong extends StatelessWidget {
  const ShapesSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Shape',
      items: shapelist,
      questions: shapesongs2,
      accent: KidsTheme.shape,
      listenMode: true,
    );
  }
}
