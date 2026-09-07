import 'package:flutter/material.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_item_detail.dart';

class BridSound extends StatelessWidget {
  final int index1;
  BridSound(this.index1, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsItemDetail(
      title: 'Birds',
      items: BRIDS1(),
      initialIndex: index1,
    );
  }
}
