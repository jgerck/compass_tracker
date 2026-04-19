import 'package:flutter/material.dart';
import 'package:compass_tracker/constants.dart';
import 'dart:math';

/*
 * Author: Joey Gercken
 * Version: 07/2025
 *
 * A CustomPainter that renders a compass dial with directional labels and a needle.
 * Draws a circular compass rose at the center of the canvas, labels each of the
 * 8 cardinal directions (N/NE/E/etc.) around its edge, and paints a red needle
 * pointing towards the specified degree.
 */
class CompassPainter extends CustomPainter {

  final double degree; // the heading in degrees (0-360), where 0° is N
  final double fontSize; // the size of the direction label text
  final double padding; // padding between the edge of the widget and compass circle

  CompassPainter(this.degree, this.fontSize, this.padding);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - padding;

    final paintCircle = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, paintCircle);

    // Draw direction text (N, NE, E, etc.)
    _drawDirectionLabels(canvas, center, radius);

    // Draw a needle pointing towards the degree
    _drawNeedle(canvas, center, radius, degree);
  }

  void _drawDirectionLabels(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < directions.length; i++) {
      final angle = (i * 45) * (pi / 180) - (pi / 2);
      final offset = Offset(
        center.dx + cos(angle) * (radius - 20),
        center.dy + sin(angle) * (radius - 20),
      );
      final textPainter = TextPainter(
        text: TextSpan(
          text: directions[i],
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, offset - Offset(6, 6));
    }
  }

  void _drawNeedle(Canvas canvas, Offset center, double radius, double degree) {
    final angle = (degree - 90) * (pi / 180); // rotate 0° to top
    final needlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + cos(angle) * (radius - 30),
      center.dy + sin(angle) * (radius - 30),
    );

    canvas.drawLine(center, needleEnd, needlePaint);
  }

  @override
  bool shouldRepaint(covariant CompassPainter oldDelegate) {
    return oldDelegate.degree != degree;
  }
}
