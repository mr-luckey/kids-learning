import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/VegitableSound.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_learning_grid.dart';

class Vegitable extends StatelessWidget {
  Vegitable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Numbermodel> items = vegitable1();
    return KidsLearningGrid(
      title: 'Vegetables',
      items: items,
      onItemTap: (BuildContext context, int index) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => VegitableSound(index),
          ),
        );
      },
    );
  }
}
