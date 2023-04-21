import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Statistics extends StatefulWidget {
  const Statistics({
    Key? key,
    required this.babyName,
    required this.babyId,
    required this.userName,
  }) : super(key: key);
  final String babyName;
  final String babyId;
  final String userName;

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Stream<QuerySnapshot>? events;
  List<DocumentSnapshot> documents = [];
  String eventType = "Sleep Time";

  @override
  void initState() {
    super.initState();
    getEventData();
  }

  getEventData() {
    DatabaseService().getEventData(widget.babyId).then((val) => {
          setState(() {
            events = val;
          })
        });
  }

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
                  getTextStyles: (value) =>
                      const TextStyle(color: Colors.black, fontSize: 12),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton(
              value: eventType,
              items: [
                DropdownMenuItem(
                    value: 'Diaper Change',
                    child: Text('Diaper Change',
                        style: AppTextTheme.body.copyWith(
                          color: AppColorScheme.white,
                        ))),
                DropdownMenuItem(
                    value: 'Meal Time',
                    child: Text('Meal Time',
                        style: AppTextTheme.body.copyWith(
                          color: AppColorScheme.white,
                        ))),
                DropdownMenuItem(
                    value: 'Sleep Time',
                    child: Text('Sleep Time',
                        style: AppTextTheme.body.copyWith(
                          color: AppColorScheme.white,
                        ))),
              ],
              onChanged: (String? value) {
                setState(() {
                  eventType = value!;
                });
              },
            ),
            StreamBuilder(
                stream: events,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    documents = snapshot.data.docs;
                    documents = documents.where((element) {
                      return element.get('type').toString() == eventType;
                    }).toList();
                    return Text("Charts go here");
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'No data available right now',
                        style: AppTextTheme.body.copyWith(
                          color: AppColorScheme.white,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColorScheme.white,
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
