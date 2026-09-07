import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/ColorSound.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_learning_grid.dart';

class Color extends StatelessWidget {
  Color({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Numbermodel> items = COLOR1();
    return KidsLearningGrid(
      title: 'Colors',
      items: items,
      onItemTap: (BuildContext context, int index) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ColorSound(index),
          ),
        );
      },
    );
  }
}
