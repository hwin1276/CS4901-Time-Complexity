import 'package:baby_tracker/pages/detailspages.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/objects/baby.dart';
import 'package:baby_tracker/pages/calendar.dart';
import 'createbaby.dart';
import 'baby_card.dart';
import '../objects/baby.dart';
import 'helper/helper_functions.dart';

class BabyList extends StatefulWidget {
  const BabyList({Key? key}) : super(key: key);

  @override
  State<BabyList> createState() => _BabyListState();
}

class _BabyListState extends State<BabyList> {
  Stream? babies;
  String email = "";
  String userName = "";

  //Sample Data To be made into a pull from a database


  getUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserBabies().then((snapshot) {
      setState(() {
        babies = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: dead_code, dead_code, dead_code
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby View'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
          ),
          Expanded(
            child: StreamBuilder(
              stream: babies,
              builder: (context, AsyncSnapshot snapshot) {
                if(snapshot.data['babies'].length == null || snapshot.data['babies'].length == 0) {
                  return Container();
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data['babies'].length,
                    itemBuilder: (context, index) {
                      return Container();
                    },
                  );
                }
              },
            ),
            // ListView(children: [
            //   Container(
            //     margin: EdgeInsets.only(
            //       top: 50,
            //       bottom: 20,
            //     ),
            //   ),
            //   for (Baby kid in babyList)
            //     BabyCard(
            //       baby: kid,
            //       onClick: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: ((context) => DetailsPages(
            //                       // pass the baby's name to Detail Page
            //                       text: kid.name,
            //                     ))));
            //       },
            //     ),
            //   // Button to add a baby profile to the view
            //   GestureDetector(
            //     onTap: () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const CreateBaby())),
            //     child: Container(
            //         margin: const EdgeInsets.all(20),
            //         height: 150,
            //         decoration: BoxDecoration(
            //           color: Colors.grey,
            //           borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(10),
            //               topRight: Radius.circular(10),
            //               bottomLeft: Radius.circular(10),
            //               bottomRight: Radius.circular(10)),
            //         ),
            //         child: Text(
            //           '+',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(fontSize: 50),
            //         )),
            //   ),
            // ]),
          )
        ],
      ),
    );
  }
}
