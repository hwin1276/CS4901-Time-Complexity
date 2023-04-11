import 'package:baby_tracker/widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';


class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<Map<String, dynamic>> _data = [
    {
      'event': 'Diaper Change',
      'data': [
        {'time': DateTime.now().subtract(Duration(days: 6)), 'value': 4},
        {'time': DateTime.now().subtract(Duration(days: 5)), 'value': 5},
        {'time': DateTime.now().subtract(Duration(days: 4)), 'value': 3},
        {'time': DateTime.now().subtract(Duration(days: 3)), 'value': 6},
        {'time': DateTime.now().subtract(Duration(days: 2)), 'value': 2},
        {'time': DateTime.now().subtract(Duration(days: 1)), 'value': 3},
        {'time': DateTime.now(), 'value': 5},
      ],
    },
    {
      'event': 'Feeding',
      'data': [
        {'time': DateTime.now().subtract(Duration(days: 6)), 'value': 5},
        {'time': DateTime.now().subtract(Duration(days: 5)), 'value': 6},
        {'time': DateTime.now().subtract(Duration(days: 4)), 'value': 4},
        {'time': DateTime.now().subtract(Duration(days: 3)), 'value': 7},
        {'time': DateTime.now().subtract(Duration(days: 2)), 'value': 3},
        {'time': DateTime.now().subtract(Duration(days: 1)), 'value': 4},
        {'time': DateTime.now(), 'value': 6},
      ],
    },
    {
      'event': 'Sleeping',
      'data': [
        {'time': DateTime.now().subtract(Duration(days: 6)), 'value': 6},
        {'time': DateTime.now().subtract(Duration(days: 5)), 'value': 7},
        {'time': DateTime.now().subtract(Duration(days: 4)), 'value': 5},
        {'time': DateTime.now().subtract(Duration(days: 3)), 'value': 8},
        {'time': DateTime.now().subtract(Duration(days: 2)), 'value': 4},
        {'time': DateTime.now().subtract(Duration(days: 1)), 'value': 5},
        {'time': DateTime.now(), 'value': 7},
      ],
    },
    {
      'event': 'Meal Per Day',
      'data': [
        {'time': DateTime.now().subtract(Duration(days: 6)), 'value': 2},
        {'time': DateTime.now().subtract(Duration(days: 5)), 'value': 3},
        {'time': DateTime.now().subtract(Duration(days: 4)), 'value': 2},
        {'time': DateTime.now().subtract(Duration(days: 3)), 'value': 4},
        {'time': DateTime.now().subtract(Duration(days: 2)), 'value': 2},
        {'time': DateTime.now().subtract(Duration(days: 1)), 'value': 3},
        {'time': DateTime.now(), 'value': 4},
      ],
    },
  ];

  List<LineChartBarData> _lineChartData = [];
  
   @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() {
  for (var i = 0; i < _data.length; i++) {
    _lineChartData.add(
      LineChartBarData(
        spots: _data[i]['data'].map((datum) {
          final time = datum['time'] as DateTime;
          final value = datum['value'] as int;
          return FlSpot(time.millisecondsSinceEpoch.toDouble(), value.toDouble());
        }).toList(),
        isCurved: true,
        colors: [Colors.blue],
        barWidth: 2,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          colors: [Colors.blue.withOpacity(0.3)],
        ),
      ),
    );
  }
}

