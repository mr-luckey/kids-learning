import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/NumberSound.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_learning_grid.dart';

class Numbers extends StatelessWidget {
  Numbers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Numbermodel> items = NumberList();
    return KidsLearningGrid(
      title: 'Numbers',
      items: items,
      onItemTap: (BuildContext context, int index) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => NumberSound(index),
          ),
        );
      },
    );
  }
}
