import 'package:flutter/material.dart';

/// HeartRatePage displays detailed information about the user's heart rate.
/// It could include historical data, graphs, and options to add new data.
class HeartRatePage extends StatefulWidget {
  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

/// The state for HeartRatePage.
/// Manages the display and interaction logic for heart rate data.
class _HeartRatePageState extends State<HeartRatePage> {
  // You can initialize heart rate data here, either with defaults or with data pulled from a database.
  // For simplicity, let's start with a default value.
  int _currentHeartRate =
      72; // A normal resting heart rate for adults ranges from 60 to 100 beats per minute.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Rate Details'),
        // Add actions if needed, such as a button for adding new heart rate data
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your current heart rate is:',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8), // Provide some spacing between text widgets.
            Text(
              '$_currentHeartRate bpm', // bpm stands for beats per minute.
              style: Theme.of(context).textTheme.headline4,
            ),
            // You can expand this widget to include more features such as:
            // - Graphs of historical heart rate data
            // - Inputs to add or edit heart rate data
            // - Analysis or insights based on the heart rate data
          ],
        ),
      ),
    );
  }
}
