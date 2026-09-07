import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/FruitSound.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_learning_grid.dart';

class Fruits extends StatelessWidget {
  Fruits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Numbermodel> items = fruit1();
    return KidsLearningGrid(
      title: 'Fruits',
      items: items,
      onItemTap: (BuildContext context, int index) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => FruitSound(index),
          ),
        );
      },
    );
  }
}
