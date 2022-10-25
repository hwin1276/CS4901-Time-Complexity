import 'package:flutter/material.dart';
import 'package:baby_tracker/objects/baby.dart';

class BabyList extends StatefulWidget {
  const BabyList({Key? key}) : super(key: key);

  @override
  State<BabyList> createState() => _BabyListState();
}

class _BabyListState extends State<BabyList> {

  //Sample Data
  List<Baby> babies = [
    Baby(babyid: 0, parentid: 0, name: 'Frank'),
    Baby(babyid: 1, parentid: 0, name: 'John'),
    Baby(babyid: 2, parentid: 1, name: 'Alex'),
    Baby(babyid: 3, parentid: 2, name: 'Justin'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Baby View'),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom:10),
                child: Text('Babies!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black)
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: babies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(20),
                      height: 150,
                      decoration: new BoxDecoration(
                        color: Colors.grey
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Container(
                                    color: Colors.blue[100],
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.child_care,
                                      size: 30
                                    )
                                  ),
                                ),
                                SizedBox(width:10),
                                Text(babies[index].name),
                              ]
                            ),
                          )
                        ],
                      )
                    );
                  },
                )
              ),
            ],
          ),
        ),
    );
  }
}
