import 'package:compass_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:compass_tracker/models/angle_entry.dart';
import 'package:compass_tracker/widgets/compass/display_compass.dart';

/*
 * Author: Joey Gercken
 * Version: 07/2025
 *
 * Displays and manages a list of angle entries, allowing the user to add new entries
 * by angle and view them in a scrollable list with timestamp, angle, compass visual,
 * and cardinal direction.
 */
class AngleEntryList extends StatefulWidget {
  const AngleEntryList({Key? key}) : super(key: key);

  @override
  AngleEntryListState createState() => AngleEntryListState();
}

class AngleEntryListState extends State<AngleEntryList> {

  final List<AngleEntry> _entries = []; // holds all recorded entries in memory
  final TextEditingController _angleController = TextEditingController(); // controller for the angle input TextField
  final _angleFocusNode = FocusNode(); // listens to the focus tree for keyboard movements (allows for rapid entries)

  // clean up to avoid null references and potential memory leaks
  @override
  void dispose() {
    _angleController.dispose();
    _angleFocusNode.dispose();
    super.dispose();
  }

  // returns the current list of angle entries
  List<AngleEntry> getEntries() {
    return _entries;
  }

  // adds a new AngleEntry, given an angle and current timestamp
  void addEntry(double angle) {
    setState(() {
      _entries.add(AngleEntry(angle: angle, timestamp: DateTime.now()));
    });
  }

  // clears current entries list and replaces them with new, imported angle entries
  void importEntries(List<AngleEntry> newEntries) {
    setState(() {
      _entries
        ..clear()
        ..addAll(newEntries);
    });
  }

  // reads the angle from the input field and validates that its within bounds (0-360),
  // and either adds a new entry or shows an error in the SnackBar
  void handleEntry() {
    final value = double.tryParse(_angleController.text);
    if (value != null && value >= 0 && value <= 360) {
      addEntry(value);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter a valid angle (0-360)')));
    }
    _angleController.clear();
    _angleFocusNode.requestFocus(); // puts focus back on text field
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // input row: text field + add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _angleController,
                    focusNode: _angleFocusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => handleEntry(), // accepts user input by pressing 'Enter'
                    style: kCardTextColor,
                    decoration: InputDecoration(
                      labelText: 'Input Compass Angle',
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white38)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(onPressed: handleEntry, child: Text('Add')),
              ],
            ),

            // header row for data table
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Row(
                children: const [
                  Expanded(flex: 2, child: Text('Time', style: kDataTableHeaderTextStyle)),
                  Expanded(child: Text('Angle', style: kDataTableHeaderTextStyle)),
                  Expanded(child: Text('Compass', style: kDataTableHeaderTextStyle)),
                  Expanded(child: Text('Direction', style: kDataTableHeaderTextStyle)),
                ],
              ),
            ),
            const Divider(),

            // one Card per entry showing its details
            ..._entries.map((entry) =>
                Card(
                  color: kCardBackgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // timestamp column
                        Expanded(flex: 2,
                            child: Text(entry.formatTimestamp(),
                                style: kCardTextColor)),

                        // angle value column
                        Expanded(child: Text(
                            entry.angle.toStringAsFixed(1),
                            style: kCardTextColor)),

                        // directional label column
                        Expanded(child: Text(
                            entry.getDirection(), style: kCardTextColor)),

                        // compass widget column
                        Flexible(
                          fit: FlexFit.loose,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 100,
                              maxHeight: 100,
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final size = constraints.maxWidth;
                                  return DisplayCompass(
                                    degree: entry.angle,
                                    size: size,
                                    fontSize: size * 0.075,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ],
        )
    );
  }
}
