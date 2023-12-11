import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class StandHoursPage extends StatefulWidget {
  @override
  _StandHoursPageState createState() => _StandHoursPageState();
}

class _StandHoursPageState extends State<StandHoursPage> {
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
            y: _random.nextDouble() * 100, // Random stand hour value
            colors: [Colors.green],
          ),
        ],
      );
    });
  }

  String _randomStandHours() {
    // Randomly generate the stand hours (this is just a placeholder)
    return '${_random.nextInt(24)}'; // Stand hours will just be a number here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stand Hours'),
        leading: BackButton(
            onPressed: () =>
                Navigator.pop(context)), // Navigates back to summary
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
                  ? 'Today: ${_randomStandHours()} stand hours'
                  : 'Average: ${_randomStandHours()} stand hours',
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
          // "About Stand Hours" section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'A “stand hour” represents an hour in your day where you stood and moved around a little for at least one minute. As much as being active is important, it’s also key to minimize the amount of time spent sitting. Even if you’re active part of the day, sitting for long periods has its own health risks.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
