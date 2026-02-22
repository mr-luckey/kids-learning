import 'package:flutter/material.dart';

/// Adventure-style card with bubbly borders and organic shape.
/// Features: white inner border, light blue bubbly outer border, soft drop shadow.
class AdventureCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final List<Color> gradientColors;
  final BorderRadius? borderRadius;

  const AdventureCard({
    Key? key,
    this.onTap,
    required this.child,
    required this.gradientColors,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(32);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              // Soft drop shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 8),
                spreadRadius: -2,
              ),
              // Bubbly outer border (light blue glow)
              BoxShadow(
                color: const Color(0xFF6DD5ED).withOpacity(0.5),
                blurRadius: 0,
                spreadRadius: 4,
              ),
              // White inner border
              BoxShadow(
                color: Colors.white,
                blurRadius: 0,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: radius,
              border: Border.all(color: Colors.white.withOpacity(0.9), width: 3),
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bubbly text style: white fill with dark blue outline (stroked text effect)
class AdventureText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign textAlign;

  const AdventureText({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark blue outline (stroke)
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontFamily: "arlrdbd",
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = const Color(0xFF1A5F7A),
          ),
        ),
        // White fill
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontFamily: "arlrdbd",
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Title text: light blue with white outline and dark shadow
class AdventureTitle extends StatelessWidget {
  final String text;
  final double fontSize;

  const AdventureTitle({
    Key? key,
    required this.text,
    this.fontSize = 26,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Dark blue shadow
          Text(
          text,
          style: TextStyle(
            fontFamily: "arlrdbd",
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = const Color(0xFF1A5F7A),
          ),
        ),
        // White outline
        Text(
          text,
          style: TextStyle(
            fontFamily: "arlrdbd",
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.white,
          ),
        ),
          // Light blue fill
          Text(
            text,
            style: TextStyle(
              fontFamily: "arlrdbd",
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6DD5ED),
            ),
          ),
        ],
      ),
    );
  }
}
