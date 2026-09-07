import 'package:flutter/material.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_item_detail.dart';

class AnimalSound extends StatelessWidget {
  final int index1;
  AnimalSound(this.index1, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsItemDetail(
      title: 'Animals',
      items: ANIMAL1(),
      initialIndex: index1,
    );
  }
}
