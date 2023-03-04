import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // meal data
  final Map<String, int> _mealData = {
    '2022-12-01': 1000,
    '2022-12-02': 1500,
    '2022-12-03': 1200,
    '2022-12-04': 900,
    '2022-12-05': 1100,
    '2022-12-06': 1300,
    '2022-12-07': 800,
  };

  // sleep data
  final Map<String, int> _sleepData = {
    '2022-12-01': 7,
    '2022-12-02': 6,
    '2022-12-03': 7,
    '2022-12-04': 8,
    '2022-12-05': 7,
    '2022-12-06': 6,
    '2022-12-07': 7,
  };

  // chart data
  List<List<num>> _mealChartData;
  List<List<num>> _sleepChartData;
  List<String> _mealLabels;
  List<String> _sleepLabels;

  // selected date range
  String _selectedDateRange = 'day';

  @override
  void initState() {
    super.initState();
    _createMealData();
    _createSleepData();
  }

  // create meal chart data
  void _createMealData() {
    List<List<num>> data = [];
    List<String> labels = [];

    DateTime now = DateTime.now();
    DateTime start;
    switch (_selectedDateRange) {
      case 'day':
        start = now.subtract(Duration(days: 1));
        break;
      case 'week':
        start = now.subtract(Duration(days: 7));
        break;
      case 'month':
        start = now.subtract(Duration(days: 30));
        break;
      case '3 months':
        start = now.subtract(Duration(days: 90));
        break;
      default:
        start = now.subtract(Duration(days: 1));
    }

    // loop through each day in the selected date range
    for (var i = start; i.isBefore(now.add(Duration(days: 1))); i = i.add(Duration(days: 1))) {
      String date = '${i.year}-${i.month.toString().padLeft(2, '0')}-${i.day.toString().padLeft(2, '0')}';
      labels.add(date);
      data.add([i.millisecondsSinceEpoch.toDouble(), _mealData[date].toDouble()]);
    }

    // set chart data and labels in state
    setState(() {
      _mealChartData = data;
      _mealLabels = labels;
    });
  }

  // create sleep chart data
  void _createSleepData() {
    List<List<num>> data = [];
    List<String> labels = [];

    DateTime now = DateTime.now();
    DateTime start;
    switch (_selectedDateRange) {
      case 'day':
        start = now.subtract(Duration(days: 1));
        break;
      case 'week':
        start = now.subtract(Duration(days: 7));
        break;
      case 'month':
        start = now.subtract(Duration(days: 30));
        break;
      case
