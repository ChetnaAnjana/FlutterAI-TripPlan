import 'package:flutter/material.dart';

class TripResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> tripData;

  TripResultsPage({required this.tripData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trip Recommendations')),
      body: tripData.isEmpty
          ? Center(child: Text('No trip data available.'))
          : ListView.builder(
              itemCount: tripData.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show the Day header or Bonus Tip header only once for each day/bonus tip
                    if (index == 0 ||
                        tripData[index]['location'] !=
                            tripData[index - 1]['location'])
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          tripData[index]['location'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    // Show the recommendations under the corresponding day or tip
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      child: Text(tripData[index]['recommendation']),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
