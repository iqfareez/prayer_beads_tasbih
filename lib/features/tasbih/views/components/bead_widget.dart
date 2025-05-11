import 'package:flutter/material.dart';

/// A single bead widget that displays a circular shape with a gradient
class BeadWidget extends StatelessWidget {
  final Color color;
  final double size;

  const BeadWidget({super.key, required this.color, this.size = 80});

  @override
  Widget build(BuildContext context) {
    // Build two circle containers, the base and the gradient layer
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.4, -0.4), // Highlight position
              radius: 0.9,
              colors: [
                Colors.white70.withValues(alpha: .63), // Bright highlight
                color, // Main bead color
                Colors.black.withValues(alpha: 0.3), // Subtle edge shading
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
