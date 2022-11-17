import 'package:baby_tracker/pages/detailspages.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/objects/baby.dart';
import 'package:baby_tracker/pages/calendar.dart';
import 'createbaby.dart';
import 'baby_card.dart';
import '../objects/baby.dart';

class BabyList extends StatefulWidget {
  const BabyList({Key? key}) : super(key: key);

  @override
  State<BabyList> createState() => _BabyListState();
}

class _BabyListState extends State<BabyList> {
  final babyList = Baby.babyList();
  //Sample Data To be made into a pull from a database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby View'),
        centerTitle: true,
      ),
      // Button to add a baby profile to the view
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CreateBaby()));
          },
          child: const Icon(Icons.add)),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 50,
                      bottom: 20,
                    ),
                  ),
                  for (Baby kid in babyList)
                    BabyCard(
                      baby: kid,
                      onClick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => DetailsPages(
                                      // pass the baby's name to Detail Page
                                      text: kid.name,
                                    ))));
                      },
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
