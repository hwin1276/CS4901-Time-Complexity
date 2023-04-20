import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StatisticsPage(),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  final List<BabyStat> diaperChangesData = [
    BabyStat(label: 'Mon', value: 6),
    BabyStat(label: 'Tue', value: 8),
    BabyStat(label: 'Wed', value: 7),
    BabyStat(label: 'Thu', value: 5),
    BabyStat(label: 'Fri', value: 6),
    BabyStat(label: 'Sat', value: 4),
    BabyStat(label: 'Sun', value: 9),
  ];

  final List<BabyStat> feedingTimesData = [
    BabyStat(label: 'Mon', value: 5),
    BabyStat(label: 'Tue', value: 6),
    BabyStat(label: 'Wed', value: 7),
    BabyStat(label: 'Thu', value: 4),
    BabyStat(label: 'Fri', value: 8),
    BabyStat(label: 'Sat', value: 6),
    BabyStat(label: 'Sun', value: 5),
  ];

  final List<BabyStat> sleepDurationsData = [
    BabyStat(label: 'Mon', value: 12),
    BabyStat(label: 'Tue', value: 14),
    BabyStat(label: 'Wed', value: 11),
    BabyStat(label: 'Thu', value: 13),
    BabyStat(label: 'Fri', value: 15),
    BabyStat(label: 'Sat', value: 10),
    BabyStat(label: 'Sun', value: 14),
  ];

  StatisticsPage({Key? key}) : super(key: key);

  Widget buildBarChart(String title, List<BabyStat> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 24)),
        SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 12),
                  getTitles: (double value) {
                    return data[value.toInt()].label;
                  },
                ),
                leftTitles: SideTitles(showTitles: false),
              ),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      y: entry.value.value.toDouble(),
                      colors: [Colors.blue],
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baby Tracker Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            buildBarChart('Diaper Changes per Day', diaperChangesData),
            SizedBox(height: 40),
            buildBarChart('Feeding Times per Day', feedingTimesData),
            SizedBox(height: 40),
                       buildBarChart('Sleep Durations per Day (hours)', sleepDurationsData),
            // Add other statistics widgets here
          ],
        ),
      ),
    );
  }
}

class BabyStat {
  final String label;
  final int value;

  BabyStat({required this.label, required this.value});
}
