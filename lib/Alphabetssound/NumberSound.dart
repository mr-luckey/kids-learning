import 'package:flutter/material.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_item_detail.dart';

class NumberSound extends StatelessWidget {
  final int index1;
  NumberSound(this.index1, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsItemDetail(
      title: 'Numbers',
      items: NumberList(),
      initialIndex: index1,
      secondaryImage: (Numbermodel item) => item.image2,
    );
  }
}
