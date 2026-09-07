import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/MonthSound.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_learning_grid.dart';

class Month extends StatelessWidget {
  Month({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Numbermodel> items = month1();
    return KidsLearningGrid(
      title: 'Months',
      items: items,
      onItemTap: (BuildContext context, int index) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MonthSound(index),
          ),
        );
      },
    );
  }
}
