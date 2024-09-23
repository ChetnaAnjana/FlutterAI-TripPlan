// Contains the user input form

import 'package:flutter/material.dart';

import 'gemini_api.dart';
import 'trip_results_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _destinationController = TextEditingController();
  String _selectedPreference = 'Adventure';
  DateTime? _selectedDate;

  // Function to pick a date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trip Planner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: _selectedDate == null
                        ? 'Pick a Date'
                        : _selectedDate.toString(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedPreference,
              items: ['Adventure', 'Relaxation', 'Culture']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPreference = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_destinationController.text.isNotEmpty &&
                    _selectedDate != null) {
                  // Call the API and navigate to the results page
                  final tripData = await GeminiAPI.planTrip(
                    _destinationController.text,
                    _selectedDate.toString(),
                    _selectedPreference,
                  );
                  print('Trip Data: $tripData');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripResultsPage(tripData: tripData),
                    ),
                  );
                }
              },
              child: Text('Plan Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
