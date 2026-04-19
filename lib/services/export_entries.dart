import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:compass_tracker/models/angle_entry.dart';

/*
 * Author: Joey Gercken
 * Version: 04/2026
 *
 * Provides functionality to export entries as a CSV or JSON file.
 */
class ExportEntries {
  // opens a save dialog and exports entries to CSV or JSON
  // returns a non-null value if the save succeeded, or null if it was canceled/failed
  Future<String?> exportWithDialog(
      List<AngleEntry> entries, {
        required String format,
      }) async {
    if (entries.isEmpty) return null; // nothing to export if list is empty

    final normalizedFormat = format.toLowerCase();

    late final String fileName;
    late final Uint8List bytes;

    // build file contents based on selected format
    if (normalizedFormat == 'csv') {
      final rows = <List<dynamic>>[
        ['timestamp', 'angle'],
        ...entries.map((e) => [e.formatTimestamp(), e.angle]),
      ];

      final csvStr = const ListToCsvConverter().convert(rows);
      fileName = 'angle_entries_export.csv';
      bytes = Uint8List.fromList(utf8.encode(csvStr));
    } else if (normalizedFormat == 'json') {
      final jsonList = entries.map((e) => e.toJson()).toList();
      final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);

      fileName = 'angle_entries_export.json';
      bytes = Uint8List.fromList(utf8.encode(jsonStr));
    } else {
      return null;
    }

    // file_picker handles save behavior across desktop + web better for this use case
    final savedLocation = await FilePicker.platform.saveFile(
      dialogTitle: 'Save export',
      fileName: fileName,
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: [normalizedFormat],
    );

    // On desktop this may be a real path.
    // On web this may not be a traditional filesystem path, but non-null still indicates success.
    return savedLocation ?? fileName;
  }
}