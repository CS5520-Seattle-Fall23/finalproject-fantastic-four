import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

// Assuming you have this file for adding sleep data.
// You will need to adjust this import to match the actual file you have for adding sleep data.
import 'add_sleep_data.dart';

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  int _selectedTimeFrame = 0; // Index for time frames: 0 = 'D', 1 = 'W', etc.
  final Random _random = Random();

  // Dummy data generation for the bar chart.
  List<BarChartGroupData> _randomBarData(int timeFrameIndex) {
    int count =
        timeFrameIndex == 0 ? 1 : 7; // 1 data point for 'D', 7 for 'W', etc.
    return List.generate(count, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: _random.nextInt(12) +
                4.0, // Random sleep time between 4 to 12 hours
            colors: [Colors.lightBlueAccent],
          ),
        ],
      );
    });
  }

  String _randomSleepTime() {
    int totalMinutes =
        _random.nextInt(480) + 120; // Random sleep time between 2 to 8 hours
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return '${hours}hr ${minutes}min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep'),
        leading: BackButton(
            onPressed: () =>
                Navigator.pop(context)), // Navigates back to summary
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to the page for adding sleep data.
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddSleepDataPage())); // Update this to your actual add data page
            },
            child: Text('Add Data', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Column(
        children: [
          ToggleButtons(
            children: ['D', 'W', 'M', '6M']
                .map((label) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(label),
                    ))
                .toList(),
            isSelected:
                List.generate(4, (index) => index == _selectedTimeFrame),
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
                  ? 'TIME IN BED ${_randomSleepTime()} Today'
                  : 'AVG. TIME IN BED ${_randomSleepTime()}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: _randomBarData(_selectedTimeFrame),
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                    show: false), // Remove axis titles for simplicity
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
