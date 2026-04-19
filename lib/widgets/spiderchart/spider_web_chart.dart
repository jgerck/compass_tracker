import 'package:flutter/material.dart';
import 'spider_painter.dart';
import 'package:compass_tracker/models/angle_entry.dart';
import 'dart:math';

/*
 * Author: Joey Gercken
 * Version: 07/2025
 *
 * A widget that sizes itself into a square and paints a spider-web chart of
 * compass angle distributions using SpiderPainter.
 */
class SpiderWebChart extends StatelessWidget {

  final List<AngleEntry> entries; // list of angle data to bin into 8 45 degree sectors
  final double padding; // padding between the edge of the graph and the widget

  const SpiderWebChart({
    Key? key,
    required this.entries,
    this.padding = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // use LayoutBuilder to adapt to parent constraints
      builder: (context, constraints) {
        // choose the smaller of width/height to keep the chart square
        final side = min(constraints.maxWidth, constraints.maxHeight);

        return Center(
          child: SizedBox(
            width: side,
            height: side,
            child: CustomPaint(
              // Delegate drawing to SpiderPainter, passing in the data in padding
              painter: SpiderPainter(entries, padding),
            ),
          ),
        );
      },
    );
  }
}
