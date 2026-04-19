import 'package:flutter/material.dart';
import 'package:compass_tracker/widgets/compass/compass_painter.dart';
import 'package:compass_tracker/constants.dart';

/*
 * Author: Joey Gercken
 * Version: 07/2025
 *
 * A widget that displays a compass dial with directional labels and a needle.
 * Wraps a CustomPaint using a CustomPainter to render:
 *    a circular compass rose with eight cardinal directions
 *    a red needle pointing towards a degree
 */
class DisplayCompass extends StatelessWidget {
  final double degree; // heading in degrees (0-360), where 0 is N
  final double size; // width and height of this square compass widget
  final double fontSize; // font size for the direction labels
  final double padding; // padding between the edge of the widget and the compass circle

  DisplayCompass({
    required this.degree,
    this.size = 100,
    this.fontSize = 12,
    this.padding = 0
  });

  // converts a degree value into one of the 8 labels on the compass
  String getCompassDirection(double degree) {
    return directions[((degree + 22.5) ~/ 45) % 8];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        // delegates all drawing to CompassPainter, given scalable arguments
        painter: CompassPainter(degree, fontSize, padding),
      ),
    );
  }
}