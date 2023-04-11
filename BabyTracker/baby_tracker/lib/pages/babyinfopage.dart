import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/showsnackbar.dart';
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
  User? user;

  @override
  void initState() {
    super.initState();
    getCareTakersandAdmin();
    user = FirebaseAuth.instance.currentUser;
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

  bool isAdmin() {
    if (FirebaseAuth.instance.currentUser!.uid == getId(admin)) {
      return true;
    }
    return false;
  }

  bool isYou(String caretakerId) {
    if (caretakerId.isNotEmpty) {
      if (FirebaseAuth.instance.currentUser!.uid == getId(caretakerId)) {
        return true;
      }
    }
    return false;
  }

  getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String theme = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "${widget.babyName}'s Caretakers",
          style: AppTextTheme.h2.copyWith(
            color: AppColorScheme.white,
          ),
        ),
        actions: [
          addEventButton(context),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  primaryCaretaker(),
                  Divider(
                    color: AppColorScheme.lightGray,
                  ),
                  allCaretakers(),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reset Baby Theme: Please restart app to after changing.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FormField(builder: (state) {
                return Column(
                  children: [
                    RadioListTile<String>(
                      value: 'red',
                      groupValue: theme,
                      title: Text("Red"),
                      onChanged: (String? value) => {
                        setState(() {
                          theme = value!;
                          FirebaseFirestore.instance
                              .collection("babies")
                              .doc(widget.babyId)
                              .update({"theme": value});
                        })
                      },
                    ),
                    RadioListTile<String>(
                      value: 'blue',
                      groupValue: theme,
                      title: Text("Blue"),
                      onChanged: (String? value) => {
                        setState(() {
                          theme = value!;
                          FirebaseFirestore.instance
                              .collection("babies")
                              .doc(widget.babyId)
                              .update({"theme": value});
                        })
                      },
                    ),
                    RadioListTile<String>(
                      value: 'green',
                      groupValue: theme,
                      title: Text("Green"),
                      onChanged: (String? value) => {
                        setState(() {
                          theme = value!;
                          FirebaseFirestore.instance
                              .collection("babies")
                              .doc(widget.babyId)
                              .update({"theme": value});
                        })
                      },
                    ),
                    RadioListTile<String>(
                      value: 'yellow',
                      groupValue: theme,
                      title: Text("Yellow"),
                      onChanged: (String? value) => {
                        setState(() {
                          theme = value!;
                          FirebaseFirestore.instance
                              .collection("babies")
                              .doc(widget.babyId)
                              .update({"theme": value});
                        })
                      },
                    ),
                  ],
                );
              })
            ],
          )
        ],
      ),
    );
  }

  IconButton addEventButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddCaretaker(
              babyId: widget.babyId,
              babyName: widget.babyName,
            ),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }

  primaryCaretaker() {
    if (admin.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColorScheme.purple.withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColorScheme.red,
              child: Text(
                getName(admin).substring(0, 1).toUpperCase(),
                style: AppTextTheme.h2.copyWith(
                  color: AppColorScheme.white,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Primary Caretaker",
                  style: AppTextTheme.h3.copyWith(color: AppColorScheme.white),
                ),
                const SizedBox(height: 10),
                Text(
                  getName(admin),
                  style:
                      AppTextTheme.body.copyWith(color: AppColorScheme.white),
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
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: (isAdmin() && !(isYou(caretakers[index])))
                ? adminOptions(index, context)
                : notAdminOptions(index),
          );
        },
      );
    } else {
      return CircularProgressIndicator(color: Theme.of(context).primaryColor);
    }
  }

  ListTile notAdminOptions(int index) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: AppColorScheme.red,
        child: Text(
          getName(caretakers[index]).substring(0, 1).toUpperCase(),
          style: AppTextTheme.h3.copyWith(color: AppColorScheme.white),
        ),
      ),
      title: Text(
        getName(caretakers[index]),
        style: AppTextTheme.h3.copyWith(color: AppColorScheme.white),
      ),
    );
  }

  ListTile adminOptions(int index, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: AppColorScheme.red,
        child: Text(getName(caretakers[index]).substring(0, 1).toUpperCase(),
            style: AppTextTheme.h3.copyWith(
              color: AppColorScheme.white,
            )),
      ),
      title: Text(getName(caretakers[index]),
          style: AppTextTheme.h3.copyWith(
            color: AppColorScheme.white,
          )),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid).kickUser(
              widget.babyId,
              widget.babyName,
              getId(caretakers[index]),
              getName(caretakers[index]));
          showSnackBar(context, AppColorScheme.green,
              "Succssfully kicked ${getName(caretakers[index])}");
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColorScheme.red,
            border: Border.all(color: AppColorScheme.white, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Kick",
            style: AppTextTheme.body.copyWith(color: AppColorScheme.white),
          ),
        ),
      ),
    );
  }
}
