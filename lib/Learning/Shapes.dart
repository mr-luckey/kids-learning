import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/ShapeSound.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_learning_grid.dart';

class Shapes extends StatelessWidget {
  Shapes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Numbermodel> items = SHAPE1();
    return KidsLearningGrid(
      title: 'Shapes',
      items: items,
      onItemTap: (BuildContext context, int index) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ShapeSound(index),
          ),
        );
      },
    );
  }
}
