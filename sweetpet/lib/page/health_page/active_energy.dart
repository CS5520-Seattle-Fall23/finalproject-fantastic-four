import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'add_active_energy_data.dart';

/// [ActiveEnergyPage] is a StatefulWidget that renders a visual representation
/// of a user's active energy expenditure over different time frames.
/// It provides interactive elements to switch between time frames and add new data.
class ActiveEnergyPage extends StatefulWidget {
  @override
  _ActiveEnergyPageState createState() => _ActiveEnergyPageState();
}

/// The state for [ActiveEnergyPage], holding logic for data generation and UI state.
class _ActiveEnergyPageState extends State<ActiveEnergyPage> {
  /// The index to track which time frame is selected ('D', 'W', 'M', '6M', 'Y').
  int _selectedTimeFrame = 0;

  /// An instance of [Random] to generate dummy data for the chart.
  final Random _random = Random();

  /// Generates data for the bar chart based on the selected time frame.
  ///
  /// [timeFrameIndex] is the index representing the current time frame.
  /// It returns a list of [BarChartGroupData] which the [BarChart] widget uses to render the bars.
  List<BarChartGroupData> _randomBarData(int timeFrameIndex) {
    int count =
        timeFrameIndex == 0 ? 24 : 7; // 24 data points for 'D', 7 for 'W', etc.
    return List.generate(count, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: _random.nextDouble() *
                (timeFrameIndex == 0 ? 60 : 300), // Random energy value
            colors: [Colors.orange],
          ),
        ],
      );
    });
  }

  /// Generates a random total calorie count.
  double _randomTotalCalories() => _random.nextDouble() * 1000;

  /// Generates a random average calorie count.
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
          // Button to navigate to the page for adding active energy data.
          TextButton(
            onPressed: () {
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
          // Toggle buttons to switch between different time frames.
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
          // Display total or average active energy based on the selected time frame.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _selectedTimeFrame == 0
                  ? 'TOTAL ${_randomTotalCalories().toStringAsFixed(1)} cal Today'
                  : 'AVERAGE ${_randomAverageCalories().toStringAsFixed(1)} cal',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          // Bar chart visualization of the active energy data.
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: _randomBarData(_selectedTimeFrame),
              ),
            ),
          ),
          // Placeholder for trend or additional data insights.
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Trend'),
          ),
        ],
      ),
    );
  }
}
