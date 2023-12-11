import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

// Assuming you have this file for adding data.
// You will need to adjust this import to match the actual file you have for adding heart rate data.
import 'add_heart_rate_data.dart';

class HeartRatePage extends StatefulWidget {
  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  int _selectedTimeFrame = 0; // Index for time frames: 0 = 'D', 1 = 'W', etc.
  final Random _random = Random();

  // Dummy data generation for the bar chart.
  List<BarChartGroupData> _randomBarData(int timeFrameIndex) {
    int count =
        timeFrameIndex == 0 ? 24 : 7; // 24 data points for 'D', 7 for 'W', etc.
    return List.generate(count, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: _random.nextDouble() * 100, // Heart rate percentage
            colors: [Colors.redAccent],
          ),
        ],
      );
    });
  }

  double _randomHeartRate() => _random.nextDouble() * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Rate'),
        leading: BackButton(
            onPressed: () =>
                Navigator.pop(context)), // Navigates back to summary
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to the page for adding heart rate data.
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddHeartRateDataPage())); // Update this to your actual add data page
            },
            child: Text('Add Data', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Column(
        children: [
          ToggleButtons(
            children: ['D', 'W', 'M', '6M', 'Y']
                .map((label) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(label),
                    ))
                .toList(),
            isSelected:
                List.generate(5, (index) => index == _selectedTimeFrame),
            onPressed: (int index) {
              setState(() {
                _selectedTimeFrame = index;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _selectedTimeFrame == 0
                  ? 'TOTAL ${_randomHeartRate().toStringAsFixed(1)}% Today'
                  : 'AVERAGE ${_randomHeartRate().toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: _randomBarData(_selectedTimeFrame),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Trend'),
          ),
          // Placeholder for other UI elements if needed.
        ],
      ),
    );
  }
}
