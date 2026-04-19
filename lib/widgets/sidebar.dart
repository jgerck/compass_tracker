import 'package:flutter/material.dart';
import 'package:compass_tracker/constants.dart';
import 'package:compass_tracker/services/import_entries.dart';
import 'package:compass_tracker/services/export_entries.dart';
import 'package:compass_tracker/widgets/angle_entry_list.dart';
import 'package:compass_tracker/widgets/spiderchart/spider_web_chart.dart';

/*
 * Author: Joey Gercken
 * Version: 04/2026
 *
 * Sidebar panel with Import/Export controls and a live-updating spider-web chart.
 */
class BuildSidebar extends StatefulWidget {
  final GlobalKey<AngleEntryListState> entryListKey;

  const BuildSidebar({
    super.key,
    required this.entryListKey,
  });

  @override
  State<BuildSidebar> createState() => _BuildSidebarState();
}

class _BuildSidebarState extends State<BuildSidebar> {
  Future<void> _handleImport() async {
    final importer = ImportEntries();
    final imported = await importer.importFile();

    if (!mounted) return;

    if (imported != null && imported.isNotEmpty) {
      widget.entryListKey.currentState?.importEntries(imported);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully imported ${imported.length} entries'),
        ),
      );

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Import canceled or file was empty/invalid'),
        ),
      );
    }
  }

  Future<void> _handleExport(String format) async {
    final entries = widget.entryListKey.currentState?.getEntries() ?? [];

    if (entries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No entries to export'),
        ),
      );
      return;
    }

    final exporter = ExportEntries();
    final result = await exporter.exportWithDialog(entries, format: format);

    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export canceled or failed'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully exported ${format.toUpperCase()} file'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.entryListKey.currentState?.getEntries() ?? [];

    return Card(
      color: kCardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                TextButton.icon(
                  icon: const Icon(
                    Icons.download_outlined,
                    color: Colors.deepPurple,
                  ),
                  label: const Text('Import'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: _handleImport,
                ),

                TextButton.icon(
                  icon: const Icon(
                    Icons.upload_file_outlined,
                    color: Colors.deepPurple,
                  ),
                  label: const Text('Export CSV'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => _handleExport('csv'),
                ),

                TextButton.icon(
                  icon: const Icon(
                    Icons.upload_file_outlined,
                    color: Colors.deepPurple,
                  ),
                  label: const Text('Export JSON'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => _handleExport('json'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: SpiderWebChart(entries: entries),
              ),
            ),
          ],
        ),
      ),
    );
  }
}