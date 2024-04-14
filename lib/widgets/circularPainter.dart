import 'dart:math';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final double progress;
  final Color backgroundColor; // Background color for the track
  final Color progressColor; // Color for the progress arc
  final double strokeWidth;

  const CirclePainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintBackground = Paint()
      ..color = backgroundColor // Set for background track
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintProgress = Paint()
      ..color = progressColor // Set for progress arc
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    // Draw the background track (full circle)
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        2 * pi, false, paintBackground);

    // Draw the progress arc
    final double arcAngle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, paintProgress);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
