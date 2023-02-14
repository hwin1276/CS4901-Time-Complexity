import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/database_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

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
  late List<_ChartData> sleepData = [];
  late List<_ChartData> eatData = [];
  late List<_ChartData> diaperData = [];
  late TooltipBehavior _tooltip;
  late TooltipBehavior _tooltip2;
  late TooltipBehavior _tooltip3;

  // Methods to call each chart
  sleepChart() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: sleepData.length.toDouble() + 10,
            interval: 10),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              dataSource: sleepData,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              name: '# Naps',
              color: Colors.green)
        ]);
  }

  eatChart() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
            minimum: 0, maximum: eatData.length.toDouble() + 10, interval: 10),
        tooltipBehavior: _tooltip2,
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              dataSource: eatData,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              name: '# Meals',
              color: Color.fromRGBO(8, 142, 255, 1))
        ]);
  }

  diaperChart() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: diaperData.length.toDouble() + 10,
            interval: 10),
        tooltipBehavior: _tooltip3,
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              dataSource: diaperData,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              name: '# Diapers',
              color: Colors.brown)
        ]);
  }

  @override
  void initState() {
    super.initState();
    getEventData();
    _tooltip = TooltipBehavior(enable: true);
    _tooltip2 = TooltipBehavior(enable: true);
    _tooltip3 = TooltipBehavior(enable: true);
  }

  getEventData() {
    DatabaseService().getEventData(widget.babyId).then((val) {
      setState(() {
        events = val;
      });
    });
  }

  // methods to query data from each week day
  napsPerDay(AsyncSnapshot snapshot) {
    int Sunday = 0,
        Monday = 0,
        Tuesday = 0,
        Wednesday = 0,
        Thursday = 0,
        Friday = 0,
        Saturday = 0;
    for (var index = 0; index < snapshot.data.docs.length; index++) {
      var weekDate = DateFormat('EEEE')
          .format(snapshot.data.docs[index]['startTime'].toDate());
      if (snapshot.data.docs[index]['type'] == "Sleep Time") {
        if (weekDate == "Sunday") {
          Sunday++;
        } else if (weekDate == "Monday") {
          Monday++;
        } else if (weekDate == "Tuesday") {
          Tuesday++;
        } else if (weekDate == "Wednesday") {
          Wednesday++;
        } else if (weekDate == "Thursday") {
          Thursday++;
        } else if (weekDate == "Friday") {
          Friday++;
        } else if (weekDate == "Saturday") {
          Saturday++;
        }
      }
    }
    sleepData.add(_ChartData("SUN", Sunday));
    sleepData.add(_ChartData("MON", Monday));
    sleepData.add(_ChartData("TUE", Tuesday));
    sleepData.add(_ChartData("WED", Wednesday));
    sleepData.add(_ChartData("THU", Thursday));
    sleepData.add(_ChartData("FRI", Friday));
    sleepData.add(_ChartData("SAT", Saturday));
  }

  mealsPerDay(AsyncSnapshot snapshot) {
    int Sunday = 0,
        Monday = 0,
        Tuesday = 0,
        Wednesday = 0,
        Thursday = 0,
        Friday = 0,
        Saturday = 0;
    for (var index = 0; index < snapshot.data.docs.length; index++) {
      var weekDate = DateFormat('EEEE')
          .format(snapshot.data.docs[index]['startTime'].toDate());
      if (snapshot.data.docs[index]['type'] == "Meal Time") {
        if (weekDate == "Sunday") {
          Sunday++;
        } else if (weekDate == "Monday") {
          Monday++;
        } else if (weekDate == "Tuesday") {
          Tuesday++;
        } else if (weekDate == "Wednesday") {
          Wednesday++;
        } else if (weekDate == "Thursday") {
          Thursday++;
        } else if (weekDate == "Friday") {
          Friday++;
        } else if (weekDate == "Saturday") {
          Saturday++;
        }
      }
    }
    eatData.add(_ChartData("SUN", Sunday));
    eatData.add(_ChartData("MON", Monday));
    eatData.add(_ChartData("TUE", Tuesday));
    eatData.add(_ChartData("WED", Wednesday));
    eatData.add(_ChartData("THU", Thursday));
    eatData.add(_ChartData("FRI", Friday));
    eatData.add(_ChartData("SAT", Saturday));
  }

  diapersPerDay(AsyncSnapshot snapshot) {
    int Sunday = 0,
        Monday = 0,
        Tuesday = 0,
        Wednesday = 0,
        Thursday = 0,
        Friday = 0,
        Saturday = 0;
    for (var index = 0; index < snapshot.data.docs.length; index++) {
      var weekDate = DateFormat('EEEE')
          .format(snapshot.data.docs[index]['startTime'].toDate());
      if (snapshot.data.docs[index]['type'] == "Diaper Change") {
        if (weekDate == "Sunday") {
          Sunday++;
        } else if (weekDate == "Monday") {
          Monday++;
        } else if (weekDate == "Tuesday") {
          Tuesday++;
        } else if (weekDate == "Wednesday") {
          Wednesday++;
        } else if (weekDate == "Thursday") {
          Thursday++;
        } else if (weekDate == "Friday") {
          Friday++;
        } else if (weekDate == "Saturday") {
          Saturday++;
        }
      }
    }
    diaperData.add(_ChartData("SUN", Sunday));
    diaperData.add(_ChartData("MON", Monday));
    diaperData.add(_ChartData("TUE", Tuesday));
    diaperData.add(_ChartData("WED", Wednesday));
    diaperData.add(_ChartData("THU", Thursday));
    diaperData.add(_ChartData("FRI", Friday));
    diaperData.add(_ChartData("SAT", Saturday));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: StreamBuilder(
          stream: events,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              napsPerDay(snapshot);
              mealsPerDay(snapshot);
              diapersPerDay(snapshot);
              return Column(children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.crib, color: Colors.green),
                    Text(" Naps"),
                  ],
                ),
                Container(
                  child: sleepChart(),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.dining, color: Colors.blue),
                    Text(" Meals"),
                  ],
                ),
                Container(child: eatChart()),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.baby_changing_station, color: Colors.brown),
                    Text(" Diaper Changes"),
                  ],
                ),
                Container(child: diaperChart()),
              ]);
            }
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }),
    ));
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
