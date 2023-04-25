import 'dart:math';
import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:intl/intl.dart";
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
  final List<SleepDataByDay> sleepData = <SleepDataByDay>[];
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

  // combineDataByDay() {
  //   int dataCount = 0;
  //   final List<SleepDataByDay> sleepData = <SleepDataByDay>[];
  //   sleepData.add(SleepDataByDay(
  //       epochTime: DateTime.parse(documents[0]["startTime"].toDate().toString())
  //               .millisecondsSinceEpoch
  //               .toDouble() -
  //           DateTime.parse(documents[0]["startTime"].toDate().toString())
  //                   .millisecondsSinceEpoch
  //                   .toDouble() %
  //               86400000,
  //       duration: documents[0]["duration"]));
  //   for (int i = 1; i < documents.length; i++) {
  //     if (DateTime.parse(documents[i - 1]["startTime"].toDate().toString())
  //                 .millisecondsSinceEpoch
  //                 .toDouble() -
  //             DateTime.parse(documents[i - 1]["startTime"].toDate().toString())
  //                     .millisecondsSinceEpoch
  //                     .toDouble() %
  //                 86400000 ==
  //         DateTime.parse(documents[i]["startTime"].toDate().toString())
  //                 .millisecondsSinceEpoch
  //                 .toDouble() -
  //             DateTime.parse(documents[i]["startTime"].toDate().toString())
  //                     .millisecondsSinceEpoch
  //                     .toDouble() %
  //                 86400000) {
  //       sleepData[dataCount].duration +=
  //           int.parse(documents[i]["duration"].toString());
  //     } else {
  //       dataCount++;
  //       sleepData.add(SleepDataByDay(
  //           epochTime: DateTime.parse(
  //                       documents[i]["startTime"].toDate().toString())
  //                   .millisecondsSinceEpoch
  //                   .toDouble() -
  //               DateTime.parse(documents[i]["startTime"].toDate().toString())
  //                       .millisecondsSinceEpoch
  //                       .toDouble() %
  //                   86400000,
  //           duration: documents[i]["duration"]));
  //     }
  //   }
  //   for (var data in sleepData) {
  //     print(data.epochTime);
  //     print(DateFormat.yMMMd()
  //         .format(DateTime.fromMillisecondsSinceEpoch(data.epochTime.toInt())));
  //     print(data.duration);
  //   }
  //   print("done");
  //   return sleepData;
  // }

  combineDataByDay() {
    Map<DateTime, int> sleepDailyData = {};
    for (var data in documents) {
      final timestamp = data["startTime"].toDate();
      final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
      if (sleepDailyData.containsKey(date)) {
        sleepDailyData[date] = (sleepDailyData[date] ?? 0) +
            int.parse(data["duration"].toString());
      } else {
        sleepDailyData[date] = int.parse(data["duration"].toString());
      }
    }
    // for (var data in sleepDailyData.entries) {
    //   print(data.key);
    //   print(data.value);
    // }
    for (var data in sleepDailyData.entries) {
      sleepData.add(SleepDataByDay(data.key, data.value));
    }

    // for (var data in sleepData) {
    //   print(data.time);
    //   print(data.duration);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dropdownFilter(),
              StreamBuilder(
                  stream: events,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      documents = snapshot.data.docs;
                      documents = documents.where((element) {
                        return element.get('type').toString() == eventType;
                      }).toList();
                      documents.sort((a, b) {
                        return a["startTime"].compareTo(b["startTime"]);
                      });
                      if (eventType == "Sleep Time") {
                        return sleepChart();
                      } else if (eventType == "Meal Time") {
                        return Text("Meal Time Chart");
                      } else {
                        return Text("Diaper Change Chart");
                      }
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
      ),
    );
  }

  AspectRatio sleepChart() {
    combineDataByDay();
    return AspectRatio(
      aspectRatio: 1,
      child: LineChart(LineChartData(
        minX: double.parse(DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 7, DateTime.now().second + 2)
            .millisecondsSinceEpoch
            .toString()),
        maxX: double.parse(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .millisecondsSinceEpoch
            .toString()),
        minY: 0,
        maxY: 500.toDouble(),
        clipData: FlClipData.all(),
        lineBarsData: [
          // LineChartBarData(
          //     spots: documents
          //         .map((e) => FlSpot(
          //             DateTime.parse(e["startTime"].toDate().toString())
          //                 .millisecondsSinceEpoch
          //                 .toDouble(),
          //             double.parse(e["duration"].toString())))
          //         .toList())
          LineChartBarData(
              spots: sleepData
                  .map((e) => FlSpot(
                      DateTime.parse(e.time.toString())
                          .millisecondsSinceEpoch
                          .toDouble(),
                      double.parse(e.duration.toString())))
                  .toList())
        ],
        gridData: FlGridData(horizontalInterval: 864000),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 86400000,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 0,
                    angle: pi / 2,
                    child: Text(DateFormat.yMMMd().format(
                        DateTime.fromMillisecondsSinceEpoch(value.toInt()))));
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      )),
    );
  }

  DropdownButton<String> dropdownFilter() {
    return DropdownButton(
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
    );
  }
}

class SleepDataByDay {
  final DateTime time;
  int duration;

  SleepDataByDay(this.time, this.duration);
}
