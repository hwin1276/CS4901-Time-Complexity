import 'package:baby_tracker/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addcaretaker.dart';

class BabyInfoPage extends StatefulWidget {
  const BabyInfoPage({
    Key? key,
    required this.babyName,
    required this.babyId,
    required this.userName,
  }) : super(key: key);
  final String babyName;
  final String babyId;
  final String userName;

  @override
  State<BabyInfoPage> createState() => _BabyInfoPageState();
}

class _BabyInfoPageState extends State<BabyInfoPage> {
  var caretakers = <dynamic>[];
  String admin = "";

  @override
  void initState() {
    super.initState();
    getCareTakersandAdmin();
  }

  getCareTakersandAdmin() {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getBabyCaretakers(widget.babyId)
        .then((val) {
      setState(() {
        caretakers = val;
      });
    });
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getBabyAdmin(widget.babyId)
        .then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.babyName}'s Caretakers"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCaretaker(
                          babyId: widget.babyId, babyName: widget.babyName)));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                primaryCaretaker(),
                Divider(
                  color: Colors.grey,
                ),
                allCaretakers(),
              ],
            ),
          )),
    );
  }

  primaryCaretaker() {
    if (admin.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.purple.withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red,
              child: Text(getName(admin).substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Primary Caretaker",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  getName(admin),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return CircularProgressIndicator(color: Theme.of(context).primaryColor);
    }
  }

  allCaretakers() {
    if (caretakers.isNotEmpty) {
      return ListView.builder(
          itemCount: caretakers.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                    child: Text(
                        getName(caretakers[index])
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        )),
                  ),
                  title: Text(getName(caretakers[index])),
                ));
          });
    } else {
      return CircularProgressIndicator(color: Theme.of(context).primaryColor);
    }
  }
}
