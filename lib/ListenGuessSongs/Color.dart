import 'package:flutter/material.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';

/// Spoken colour names for the listen-and-guess round, one per question.
List<Numbermodel> colorlist = COLOR1();

/// "Hear the colour, tap the swatch."
class ColorSong extends StatelessWidget {
  const ColorSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsQuizScreen(
      title: 'Color',
      items: colorlist,
      questions: colorsongs2,
      accent: KidsTheme.color,
      listenMode: true,
    );
  }
}
