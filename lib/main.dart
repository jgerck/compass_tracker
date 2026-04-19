import 'package:flutter/material.dart';
import 'package:compass_tracker/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compass Data Log',
      home: HomeScreen(),
    );
  }
}

