import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShapedContainer extends StatefulWidget {
  final double width;
  final double height;
  final double R; // Major radius
  final double a; // Minor radius amplitude
  final double n; // Frequency multiplier
  final int steps; // Number of points to calculate
  final Color color;
  final int rotationLen; // Length of the rotation
  final Widget? child;

  ShapedContainer({
    super.key,
    required this.width,
    required this.height,
    required this.R,
    required this.a,
    required this.n,
    required this.color,
    this.child,
    this.rotationLen = 5, // Default rotation length
    this.steps = 1000, // Default number of steps
  }){
    assert(
         R > 0 && a >= 0 && n > 0,
         'R must be positive, a must be non-negative, and n must be positive',
       );
  }
@override
  State<ShapedContainer> createState() => _ShapedContainerState();
}

class _ShapedContainerState extends State<ShapedContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Start the animation
    _controller = AnimationController(
      vsync:this,
      duration: Duration(seconds: widget.rotationLen), // Use rotationLen for duration
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: ClipPath(
      clipper: SpirographClipper(R: widget.R, a: widget.a, n: widget.n, steps: widget.steps),
      child: Container(
        width: widget.width,
        height: widget.height,
        color: widget.color,
        child: widget.child,
      ),
    ));
  }
}

class SpirographClipper extends CustomClipper<Path> {
  final double R; // Major radius
  final double a; // Minor radius amplitude
  final double n; // Frequency multiplier
  final int steps; // Number of points to calculate

  const SpirographClipper({
    required this.R,
    required this.a,
    required this.n,
    this.steps = 1000,
  });

  @override
  Path getClip(Size size) {
    return _createSpirographPath(size);
  }

  Path _createSpirographPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Calculate scale factor based on container size
    // The maximum possible radius is R + a (when sin(nt) = 1)
    final maxRadius = R + a;
    
    // Use the smaller dimension to ensure the shape fits
    final containerRadius = math.min(size.width, size.height) / 2;
    
    // Scale factor to fit the spirograph within the container
    // Leave some padding (multiply by 0.9 for 10% padding)
    final scaleFactor = (containerRadius * 0.9) / maxRadius;

    // Calculate the range of t values for a complete pattern
    final maxT = 2 * math.pi * (n.ceil());

    bool firstPoint = true;

    for (int i = 0; i <= steps; i++) {
      final t = (i / steps) * maxT;

      // Your equation: ((R + a*sin(n*t))*cos(t), (R + a*sin(n*t))*sin(t))
      final radius = (R + a * math.sin(n * t)) * scaleFactor;
      final x = centerX + radius * math.cos(t);
      final y = centerY + radius * math.sin(t);

      if (firstPoint) {
        path.moveTo(x, y);
        firstPoint = false;
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant SpirographClipper oldClipper) {
    return oldClipper.R != R ||
           oldClipper.a != a ||
           oldClipper.n != n ||
           oldClipper.steps != steps;
  }
}