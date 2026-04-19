import 'package:flutter/material.dart';
import 'package:compass_tracker/constants.dart';
import 'package:compass_tracker/models/angle_entry.dart';
import 'dart:math';

/*
 * Author: Joey Gercken
 * Version: 07/2025
 *
 * A CustomPainter that visualizes compass angle distribution through a spider-web chart.
 * Processes a list of AngleEntry objects into 8 directional bins and renders:
 *    concentric guide rings (for scale and interpretation purposes)
 *    radial exes every 45 degrees, following same format as the CompassPainter
 *    a filled polygon whose vertices lie at distances proportional to the count
 *      of entries in each directional bin
 *    outline and labels for each compass direction around the edge
 */
class SpiderPainter extends CustomPainter {
  final List<AngleEntry> entries; // raw angle data to bin and plot
  final double padding; // inner spacing from the widget's bounds to the outer ring

  SpiderPainter(this.entries, this.padding);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height /2);
    final double radius = min(size.width, size.height) / 2 - padding;

    final bins = _computeBins(entries); // raw counts per bucket
    final data = bins.map((c) => c.toDouble()).toList(); // converts bin data to doubles
    final maxValue = data.isEmpty ? 1.0 : data.reduce((a, b) => a > b ? a : b);

    final scaledValues = data.map((d) => (d / maxValue) * radius).toList();

    // Draw concentric guides
    final guidePaint = Paint()
      ..color = Colors.white24 // cascade operator to avoid variable name repetition
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const int rings = 4;
    for (int r = 1; r <= rings; r++) {
      final double ringRadius = radius * (r / rings);
      canvas.drawCircle(center, ringRadius, guidePaint);
    }

    // Draw radial lines
    final axisPaint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 1;

    for (int i = 0; i < 8; i++) {
      final double angle = i * 45 - 90;
      final double rad = (angle * pi) / 180;
      final Offset end = Offset(
          center.dx + cos(rad) * radius,
          center.dy + sin(rad) * radius
      );
      canvas.drawLine(center, end, axisPaint);
    }

    // Plot and fill data polygon
    final dataPaint = Paint()
      ..color = Colors.deepPurple.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path dataPath = Path();
    for (int i = 0; i < scaledValues.length; i++) {
      final double angle = i * 45 - 90;
      final double rad = (angle * pi) / 180;
      final double dist = scaledValues[i];
      final Offset point = Offset(
        center.dx + cos(rad) * dist,
        center.dy + sin(rad) * dist,
      );

      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    dataPath.close();

    canvas.drawPath(dataPath, dataPaint);
    canvas.drawPath(dataPath, outlinePaint);

    for (int i = 0; i < 8; i++) {
      final double angle = i * 45 - 90;
      final double rad = (angle * pi) / 180;
      final Offset labelPos = Offset(
        center.dx + cos(rad) * (radius + 16),
        center.dy + sin(rad) * (radius + 16),
      );
      
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: TextStyle(color: Colors.white, fontSize: 12)),
        textDirection: TextDirection.ltr,
      )..layout();

      final offset = labelPos - Offset(tp.width / 2, tp.height / 2);
      tp.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant SpiderPainter old) => true;

  List<int> _computeBins(List<AngleEntry> entries) {
    final bins = List<int>.filled(8, 0);
    for (final entry in entries) {
      final index = ((entry.angle + 22.5) ~/ 45) % 8;
      bins[index]++;
    }
    return bins;
  }
}