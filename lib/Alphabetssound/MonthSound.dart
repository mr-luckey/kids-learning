import 'package:flutter/material.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_item_detail.dart';

class MonthSound extends StatelessWidget {
  final int index1;
  MonthSound(this.index1, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsItemDetail(
      title: 'Months',
      items: month1(),
      initialIndex: index1,
    );
  }
}
