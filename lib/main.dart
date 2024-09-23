import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(TripPlannerApp());
}

class TripPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
