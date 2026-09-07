import 'package:flutter/material.dart';
import 'package:kids/widgets/kids_sky_background.dart';

/// Back-compat wrapper — every old screen that still imports this now gets
/// the animated sky + meadow redesign automatically.
class AdventureBackground extends StatelessWidget {
  final Widget child;

  const AdventureBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KidsSkyBackground(child: child);
  }
}
