import 'package:compass_tracker/constants.dart';
import 'package:intl/intl.dart';

/*
 * Author: Joey Gercken
 * Version: 07/2025
 *
 * Represents a single compass entry with a timestamp and angle.
 */
class AngleEntry {

  final DateTime timestamp; // time when the reading was recorded
  final double angle; // angle at which the compass points to, in degrees (0-360)

  // create a new entry with the required timestamp and angle
  AngleEntry({required this.timestamp, required this.angle});

  // formats the timestamp as a readable string
  String formatTimestamp() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);
  }

  // converts the angle into a compass direction label
  // offset by 22.5° so each 45° sector maps to one of the 8 directions
  String getDirection() {
    return directions[((angle + 22.5) ~/ 45) % 8];
  }

  // serializes an entry to JSON for export
  Map<String, dynamic> toJson() {
    return {
      'timestamp': formatTimestamp(),
      'angle': angle,
    };
  }
}