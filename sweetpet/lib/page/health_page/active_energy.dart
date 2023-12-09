import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'add_active_energy_data.dart'; // Assuming you have this file for adding data.

class ActiveEnergyPage extends StatefulWidget {
  @override
  _ActiveEnergyPageState createState() => _ActiveEnergyPageState();
}

class _ActiveEnergyPageState extends State<ActiveEnergyPage> {
  int _selectedTimeFrame = 0; // Index for time frames: 0 = 'D', 1 = 'W', etc.
  final Random _random = Random();

  // Dummy data generation for the bar chart.
  List<BarChartGroupData> _randomBarData(int timeFrameIndex) {
    // You can adjust the range based on the timeframe if needed.
    int count =
        timeFrameIndex == 0 ? 24 : 7; // 24 hours for 'D', 7 days for 'W', etc.
    return List.generate(count, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: _random.nextDouble() *
                (timeFrameIndex == 0 ? 60 : 300), // Adjust the max value
            colors: [Colors.orange],
          ),
        ],
      );
    });
  }

  double _randomTotalCalories() => _random.nextDouble() * 1000;
  double _randomAverageCalories() => _random.nextDouble() * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Energy'),
        leading: BackButton(
            onPressed: () =>
                Navigator.pop(context)), // Navigates back to summary
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to the page for adding data.
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddActiveEnergyDataPage()));
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
                  ? 'TOTAL ${_randomTotalCalories().toStringAsFixed(1)} cal Today'
                  : 'AVERAGE ${_randomAverageCalories().toStringAsFixed(1)} cal',
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
