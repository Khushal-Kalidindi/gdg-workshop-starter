import 'package:flutter/material.dart';

class Shape {
  final double R; // Major radius
  final double a; // Minor radius amplitude
  final double n; // Frequency multiplier
  final int steps; // Number of steps to draw the shape
  final double width; // Width of the container
  final double height; // Height of the container
  final Color color; // Color of the container
  final int rotationLen;
  final double top;
  final double left; 
  Widget? child; // Optional child widget

  Shape({
    required this.R,
    required this.a,
    required this.n,
    this.steps = 1000, // Default steps for the shape
    required this.width,
    required this.height,
    required this.color,
    required this.rotationLen,
    required this.top,
    required this.left,
    this.child,
  });

}