import 'dart:math';
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

  // Combines data in cases where an event can happen multiple times a day.
  // The combined data has both of it's values combined.
  combineDataByDay(String range, String eventType) {
    // check for range
    int dataLength = 0;
    if (range == "1 Week") {
      dataLength = 7;
    } else {
      dataLength = 28;
    }

    // sets initial data value to zero
    Map<int, int> result = {};
    DateTime currentDate =
        DateTime.now().subtract(Duration(days: dataLength - 1));
    int dayIndex = 0;
    while (currentDate.isBefore(DateTime.now())) {
      result[dayIndex] = 0;
      dayIndex++;
      currentDate = currentDate.add(Duration(days: 1));
    }

    // fills result with the duration
    // The current date is subtracted by the range (4 weeks or 1 week). Then the
    // days are iterated through adding the data.values together that are on the
    // same day until today is reached.
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

    // clears data for when the user switches the filter or range
    eventData.clear();

    // fill data into a list.
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
                      // fiters and sorts events
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
                            color: Theme.of(context).textTheme.bodySmall?.color,
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
    // check for range
    if (range == "1 Week") {
      maxX = 6;
      interval = 1.0;
    } else {
      maxX = 27;
      interval = 4.0;
    }

    // filters events
    if (eventType == "Meal Time") {
      maxY = 1200;
    } else if (eventType == "Sleep Time") {
      maxY = 1000;
    } else {
      maxY = 20;
    }

    // Combines data in cases where an event can happen multiple times a day.
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
          // uses the event data as y and the numbered key as x
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
                    // default tooltip
                    final flSpot = barSpot;

                    // calculates the date from x value
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

                    // create new tooltip
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
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ))),
        DropdownMenuItem(
            value: '4 Weeks',
            child: Text('4 Weeks',
                style: AppTextTheme.body.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
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
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ))),
        DropdownMenuItem(
            value: 'Meal Time',
            child: Text('Meal Time',
                style: AppTextTheme.body.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ))),
        DropdownMenuItem(
            value: 'Sleep Time',
            child: Text('Sleep Time',
                style: AppTextTheme.body.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
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

class DataByDay {
  int day;
  int data;

  DataByDay(this.day, this.data);
}
