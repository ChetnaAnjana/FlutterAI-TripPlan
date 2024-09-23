import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiAPI {
  static const String _apiBaseUrl =
      "https://api.openai.com/v1/chat/completions";
  static const String _apiKey =
      "sk-8zDPS1n-bfrN9E2prfjdWT0prRFmeUn-lz2dLZSvd8T3BlbkFJOrLbFqw2CE2bioHjJxvLz4Y_0tfp7GAFHx8HPKq1cA";
  static Future<List<Map<String, dynamic>>> planTrip(
      String destination, String date, String preference) async {
    final url = Uri.parse(_apiBaseUrl);

    final requestBody = jsonEncode({
      'model': 'gpt-4',
      'messages': [
        {
          'role': 'user',
          'content':
              'Plan a trip to $destination on $date with preferences for $preference.'
        }
      ],
      'max_tokens': 500,
      'temperature': 0.7
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tripText = data['choices'][0]['message']['content'];

      // Log the response to verify
      print('Trip Text: $tripText');

      // Process the trip text into structured data
      final tripData = _processTripText(tripText);
      return tripData;
    } else {
      print('Error: ${response.body}');
      throw Exception('Failed to retrieve trip data: ${response.statusCode}');
    }
  }

  // Helper function to process the text into structured trip data
  static List<Map<String, dynamic>> _processTripText(String tripText) {
    final List<Map<String, dynamic>> tripData = [];

    // Split the text by lines first to examine the structure
    final lines = tripText.split('\n');

    int dayCounter = 0;
    String currentDay = '';

    // Iterate over each line
    for (String line in lines) {
      line = line.trim();

      // Check for conclusion or bonus tip keywords like "Remember", "Note", etc.
      if (line.startsWith('Remember') ||
          line.startsWith('Note') ||
          line.contains('weather')) {
        tripData.add({
          'location': 'Bonus Tip',
          'recommendation': line.trim(),
        });
      }
      // Check if the line starts with "Day X"
      else if (RegExp(r'^Day \d').hasMatch(line)) {
        dayCounter++;
        currentDay = 'Day $dayCounter';
      }
      // Add day recommendations under the correct day heading
      else if (line.isNotEmpty) {
        if (dayCounter == 0) continue;
        tripData.add({
          'location': currentDay,
          'recommendation': line.trim(),
        });
      }
    }

    return tripData;
  }
}
