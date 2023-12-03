import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class ActiveEnergyPage extends StatefulWidget {
  @override
  _ActiveEnergyPageState createState() => _ActiveEnergyPageState();
}

class _ActiveEnergyPageState extends State<ActiveEnergyPage> {
  int _selectedTimeFrame = 0; // 0 for D, 1 for W, etc.
  final Random _random = Random();

  // Dummy data generator for the bar chart
  List<BarChartGroupData> _randomBarData() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: _random.nextDouble() * 500,
            colors: [Colors.orange],
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Energy'),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
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
              'TOTAL ${_random.nextInt(1000)} kcal',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: _randomBarData(),
              ),
            ),
          ),
          // Placeholder for other widgets
        ],
      ),
    );
  }
}
