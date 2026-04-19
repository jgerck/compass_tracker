import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:compass_tracker/models/angle_entry.dart';

/*
 * Author: Joey Gercken
 * Version: 04/2026
 *
 * Handles importing compass angle entries from external files.
 */
class ImportEntries {
  /*
   * Opens a platform-native file picker, allowing the user to select a CSV or JSON file.
   * Then parses its contents into a list of AngleEntry objects.
   * Returns null if the user cancels or if the file is empty/invalid.
   */
  Future<List<AngleEntry>?> importFile() async {
    // let the user pick between a .csv or .json file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'json'],
      withData: true,
    );

    // if cancelled, there's nothing to import
    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.single;
    final rawBytes = file.bytes;

    // on web, bytes are the important part
    // on desktop, this also works fine with withData: true
    if (rawBytes == null || rawBytes.isEmpty) {
      return null;
    }

    final raw = utf8.decode(rawBytes);
    final ext = (file.extension ?? '').toLowerCase();

    if (ext == 'json') {
      return _parseJson(raw);
    } else if (ext == 'csv') {
      return _parseCsv(raw);
    }

    return null;
  }

  List<AngleEntry>? _parseJson(String raw) {
    try {
      final decoded = json.decode(raw);

      if (decoded is! List) return null;

      return decoded.map<AngleEntry>((item) {
        final map = item as Map<String, dynamic>;
        return AngleEntry(
          timestamp: DateTime.parse(map['timestamp'] as String),
          angle: (map['angle'] as num).toDouble(),
        );
      }).toList();
    } catch (_) {
      return null;
    }
  }

  List<AngleEntry>? _parseCsv(String raw) {
    try {
      final rows = const CsvToListConverter().convert(raw).cast<List<dynamic>>();

      if (rows.isEmpty) return null;

      final header =
      rows.first.map((e) => e.toString().trim().toLowerCase()).toList();

      int timestampIndex = header.indexOf('timestamp');
      int angleIndex = header.indexOf('angle');

      // fallback if header names are missing but columns are still in expected order
      if (timestampIndex < 0 || angleIndex < 0) {
        timestampIndex = 0;
        angleIndex = 1;
      }

      final imported = <AngleEntry>[];

      for (final row in rows.skip(1)) {
        if (row.length <= timestampIndex || row.length <= angleIndex) {
          continue;
        }

        try {
          imported.add(
            AngleEntry(
              timestamp: DateTime.parse(row[timestampIndex].toString()),
              angle: double.parse(row[angleIndex].toString()),
            ),
          );
        } catch (_) {
          // skip malformed rows instead of failing the whole import
          continue;
        }
      }

      return imported.isEmpty ? null : imported;
    } catch (_) {
      return null;
    }
  }
}