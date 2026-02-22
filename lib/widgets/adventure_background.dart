import 'package:flutter/material.dart';

/// Sky + landscape background with floating bubbles
class AdventureBackground extends StatelessWidget {
  final Widget child;

  const AdventureBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFB8E6F5), // Light blue sky
            Color(0xFFA8DFF0),
            Color(0xFF90D4E8),
            Color(0xFF7BCF82), // Green hills
            Color(0xFF6BC473),
            Color(0xFF5BB863),
          ],
          stops: [0.0, 0.35, 0.5, 0.7, 0.85, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Floating bubbles
          ...List.generate(12, (i) {
            final top = 0.05 + (i * 0.08) % 0.85;
            final left = 0.05 + (i * 0.17) % 0.85;
            final size = 20.0 + (i % 5) * 12.0;
            return Positioned(
              top: MediaQuery.of(context).size.height * top,
              left: MediaQuery.of(context).size.width * left,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
              ),
            );
          }),
          child,
        ],
      ),
    );
  }
}
