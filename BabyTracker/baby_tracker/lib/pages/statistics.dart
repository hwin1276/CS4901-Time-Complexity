import 'dart:collection';
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
  final List<DataByDay> eventData = <DataByDay>[];
  final List<String> weekDays = [
    'Mon',
    'Tues',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  String eventType = "Sleep Time";
  String rangeFilter = "1 Week";

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

  // Solution calculated using 86400 as a day
  // Not recommended because 86400 is not always a day (there are leap seconds)
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
  //   return sleepData;
  // }

  // Solution using DateTime for days. Stores Datetime in a map with sleep duration
  // combineDataByDay() {
  //   Map<DateTime, int> sleepDailyData = {};
  //   for (var data in documents) {
  //     final timestamp = data["startTime"].toDate();
  //     final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
  //     if (sleepDailyData.containsKey(date)) {
  //       sleepDailyData[date] = (sleepDailyData[date] ?? 0) +
  //           int.parse(data["duration"].toString());
  //     } else {
  //       sleepDailyData[date] = int.parse(data["duration"].toString());
  //     }
  //   }
  //   for (var data in sleepDailyData.entries) {
  //     sleepData.add(SleepDataByDay(data.key, data.value));
  //   }
  // }

  combineDataByDay(String range, String eventType) {
    int dataLength = 0;
    if (range == "1 Week") {
      dataLength = 7;
    } else {
      dataLength = 28;
    }

    Map<int, int> result = {};

    DateTime currentDate =
        DateTime.now().subtract(Duration(days: dataLength - 1));
    int dayIndex = 0;
    // sets initial sleep duration to zero for the entire week.
    while (currentDate.isBefore(DateTime.now())) {
      result[dayIndex] = 0;
      dayIndex++;
      currentDate = currentDate.add(Duration(days: 1));
    }

    // fills result with numbered duration
    for (var data in documents) {
      final timestamp = data["startTime"].toDate();
      DateTime date = DateTime(timestamp.year, timestamp.month, timestamp.day);
      if (date.isAfter(DateTime.now().subtract(Duration(days: dataLength)))) {
        int offset = DateTime.now().difference(date).inDays;
        if (offset < dataLength) {
          if (eventType == "Sleep Time") {
            result[dataLength - 1 - offset] =
                (result[dataLength - 1 - offset] ?? 0) +
                    int.parse(data["duration"].toString());
          } else if (eventType == "Meal Time") {
            result[dataLength - 1 - offset] =
                (result[dataLength - 1 - offset] ?? 0) +
                    int.parse(data["calories"].toString());
          } else {
            result[dataLength - 1 - offset] =
                (result[dataLength - 1 - offset] ?? 0) + 1;
          }
        }
      }
    }

    // // fills result with numbered duration
    // for (var data in documents) {
    //   final timestamp = data["startTime"].toDate();
    //   DateTime date = DateTime(timestamp.year, timestamp.month, timestamp.day);
    //   if (date.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
    //     int offset = DateTime.now().difference(date).inDays;
    //     if (offset < 7) {
    //       result[6 - offset] = (result[6 - offset] ?? 0) +
    //           int.parse(data["duration"].toString());
    //     }
    //   }
    // }

    eventData.clear();
    //fill sleep data
    for (var data in result.entries) {
      eventData.add(DataByDay(data.key, data.value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                eventDropDown(),
                rangeDropDown(),
              ]),
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
                        return chart(rangeFilter, eventType);
                      } else if (eventType == "Meal Time") {
                        return chart(rangeFilter, eventType);
                      } else {
                        return chart(rangeFilter, eventType);
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

  AspectRatio chart(String range, String eventType) {
    double minX = 0.0;
    double maxX = 0.0;
    double minY = 0.0;
    double maxY = 0.0;
    double interval = 0.0;
    // max is decreased by one because you start counting at 0.
    if (range == "1 Week") {
      maxX = 6;
      interval = 1.0;
    } else {
      maxX = 27;
      interval = 4.0;
    }

    if (eventType == "Meal Time") {
      maxY = 1200;
    } else if (eventType == "Sleep Time") {
      maxY = 1000;
    } else {
      maxY = 20;
    }

    combineDataByDay(range, eventType);
    return AspectRatio(
      aspectRatio: 1,
      child: LineChart(LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        clipData: FlClipData.all(),
        lineBarsData: [
          // epoch day 86400 solution
          // LineChartBarData(
          //     spots: documents
          //         .map((e) => FlSpot(
          //             DateTime.parse(e["startTime"].toDate().toString())
          //                 .millisecondsSinceEpoch
          //                 .toDouble(),
          //             double.parse(e["duration"].toString())))
          //         .toList())

          // date time as key
          // LineChartBarData(
          //     spots: sleepData
          //         .map((e) => FlSpot(
          //             DateTime.parse(e.time.toString())
          //                 .millisecondsSinceEpoch
          //                 .toDouble(),
          //             double.parse(e.duration.toString())))
          //         .toList())

          // steps as key
          LineChartBarData(
              spots: eventData
                  .map((e) => FlSpot(double.parse(e.day.toString()).toDouble(),
                      double.parse(e.data.toString())))
                  .toList())
        ],
        lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final flSpot = barSpot;
                    // DateTime date = DateTime.now()
                    //     .subtract(Duration(days: 28))
                    //     .add(Duration(days: flSpot.x.toInt() + 1));
                    DateTime date = DateTime.now();
                    if (range == "4 Weeks") {
                      date = DateTime.now()
                          .subtract(Duration(days: 28))
                          .add(Duration(days: flSpot.x.toInt() + 1));
                    } else {
                      date = DateTime.now()
                          .subtract(Duration(days: 7))
                          .add(Duration(days: flSpot.x.toInt() + 1));
                    }
                    if (eventType == "Meal Time") {
                      return LineTooltipItem(
                          "${weekDays[date.weekday - 1]} ${date.month}/${date.day}\n${flSpot.y.toInt()} calories",
                          TextStyle(
                              color: AppColorScheme.black,
                              fontWeight: FontWeight.bold));
                    } else if (eventType == "Sleep Time") {
                      return LineTooltipItem(
                          "${weekDays[date.weekday - 1]} ${date.month}/${date.day}\n${flSpot.y.toInt()} minutes",
                          TextStyle(
                              color: AppColorScheme.black,
                              fontWeight: FontWeight.bold));
                    } else {
                      return LineTooltipItem(
                          "${weekDays[date.weekday - 1]} ${date.month}/${date.day}\n${flSpot.y.toInt()} diaper changes",
                          TextStyle(
                              color: AppColorScheme.black,
                              fontWeight: FontWeight.bold));
                    }
                  }).toList();
                })),
        gridData: FlGridData(verticalInterval: interval),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              getTitlesWidget: (value, meta) {
                if (range == "1 Week") {
                  return Text(weekDays[((DateTime.now()
                          .add(Duration(days: value.toInt() + 1))
                          .weekday -
                      1))]);
                } else {
                  DateTime date = DateTime.now()
                      .subtract(Duration(days: 28))
                      .add(Duration(days: value.toInt() + 1));
                  return SideTitleWidget(
                      angle: pi / 2,
                      axisSide: meta.axisSide,
                      child: Text("     ${date.month}/${date.day}"));
                }
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      )),
    );
  }

  DropdownButton<String> rangeDropDown() {
    return DropdownButton(
      value: rangeFilter,
      items: [
        DropdownMenuItem(
            value: '1 Week',
            child: Text('1 Week',
                style: AppTextTheme.body.copyWith(
                  color: AppColorScheme.white,
                ))),
        DropdownMenuItem(
            value: '4 Weeks',
            child: Text('4 Weeks',
                style: AppTextTheme.body.copyWith(
                  color: AppColorScheme.white,
                ))),
      ],
      onChanged: (String? value) {
        setState(() {
          rangeFilter = value!;
        });
      },
    );
  }

  DropdownButton<String> eventDropDown() {
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

// class SleepDataByDay {
//   final DateTime time;
//   int duration;

//   SleepDataByDay(this.time, this.duration);
// }

class DataByDay {
  int day;
  int data;

  DataByDay(this.day, this.data);
}
