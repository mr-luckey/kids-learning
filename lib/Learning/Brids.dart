import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/BridSound.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_learning_grid.dart';

class Brids extends StatelessWidget {
  Brids({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Numbermodel> items = BRIDS1();
    return KidsLearningGrid(
      title: 'Birds',
      items: items,
      onItemTap: (BuildContext context, int index) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => BridSound(index),
          ),
        );
      },
    );
  }
}
