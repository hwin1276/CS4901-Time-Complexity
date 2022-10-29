import 'package:baby_tracker/pages/detailspages.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/objects/baby.dart';
import 'package:baby_tracker/pages/calendar.dart';
import 'baby_card.dart';


class BabyList extends StatefulWidget {
  const BabyList({Key? key}) : super(key: key);

  @override
  State<BabyList> createState() => _BabyListState();
}

class _BabyListState extends State<BabyList> {

  //Sample Data To be made into a pull from a database
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
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom:10),
                child: Text('Babies!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black)
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: babies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BabyCard(
                        baby: babies[index],
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailsPages()
                            )
                          );
                        }
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
