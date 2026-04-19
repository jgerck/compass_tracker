import 'package:flutter/material.dart';
import 'package:compass_tracker/widgets/sidebar.dart';
import 'package:compass_tracker/widgets/angle_entry_list.dart';

/*
 * Author: Joey Gercken
 * version: 07/2025
 *
 * Main screen displaying the list of entries in table form as well as a graph
 * off to the right.
 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final GlobalKey<AngleEntryListState> entryListKey = GlobalKey<AngleEntryListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Compass Angle Entries'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: AngleEntryList(key: entryListKey), // Displays recorded entries
              )
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(8.0), child: BuildSidebar(entryListKey: entryListKey)
            ),
          ),
        ],
      ),
    );
  }
}
