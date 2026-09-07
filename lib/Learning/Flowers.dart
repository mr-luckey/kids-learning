import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/FlowerSound.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_learning_grid.dart';

class Flower extends StatelessWidget {
  Flower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Numbermodel> items = FLOWERS1();
    return KidsLearningGrid(
      title: 'Flowers',
      items: items,
      onItemTap: (BuildContext context, int index) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => FlowerSound(index),
          ),
        );
      },
    );
  }
}
