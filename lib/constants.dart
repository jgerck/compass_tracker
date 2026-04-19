import 'package:flutter/material.dart';

// list of cardinal direction labels and their corresponding degree labels
const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
const labels = ['0°','45°','90°','135°','180°','225°','270°','315°'];

// card background color for any angle entries and the side panel
const kCardBackgroundColor = Color(0xFF212121);

// data table header style to reduce code redundancy
const kDataTableHeaderTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold,
);

// card text color to reduce code redundancy
const kCardTextColor = TextStyle(color: Colors.white);