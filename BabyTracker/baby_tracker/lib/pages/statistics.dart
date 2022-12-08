// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/Models/events.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class Statistics extends StatefulWidget {
  //const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  DateTime today = new DateTime.now(); // this is for getting all data from today
  // the below is where I create a list for the bar graph
  List<charts.Series<Event,String>> _barGraphData = [];
  List<Event> babyData = [];
  _generateData(babyData){
   //_barGraphData = List<charts.Series<Event, String>>.empty();
    _barGraphData.add(
      charts.Series(
        domainFn: (Event events,_)=> events.type.toString(), // x axis value 
        measureFn: (Event events,_)=> babyData.addAll(events.start.toString().substring(0,10) == today.toString().substring(0,10)), //y axis calculating only inputs for today
        //measureFn: (Event events,_)=> babyData.addAll(events), // y axis values
        colorFn: (Event events,_)=> charts.MaterialPalette.blue.shadeDefault,
        id: 'Daily-Events',
        data: babyData,
      )
    );
  }
  
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todays Events')),
        body: _buildBody(context),
            // child: Text(
            //     'Statistics View to be Added'
            //)
        );
  }

  Widget _buildBody(context){
    return StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return LinearProgressIndicator();
        } else {
        List<Event> events = snapshot.data!.docs.map((documentSnapshot)=> Event.fromMap(documentSnapshot.data())).toList();
        return _buildChart(context, events);
        }
      },
    );
  }

 Widget _buildChart(BuildContext context, List<Event> data) {
    babyData = data;
    _generateData(babyData);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Events input today',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(_barGraphData,
                    animate: true,
                    animationDuration: Duration(seconds:2),
                     behaviors: [
                      charts.DatumLegend(
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 18),
                      )
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
