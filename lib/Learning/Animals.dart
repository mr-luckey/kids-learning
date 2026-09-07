import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/AnimalsSound.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_learning_grid.dart';

class Animal extends StatelessWidget {
  Animal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Numbermodel> items = ANIMAL1();
    return KidsLearningGrid(
      title: 'Animals',
      items: items,
      onItemTap: (BuildContext context, int index) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => AnimalSound(index),
          ),
        );
      },
    );
  }
}
