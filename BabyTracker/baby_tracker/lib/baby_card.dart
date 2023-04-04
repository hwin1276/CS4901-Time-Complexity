import 'package:baby_tracker/pages/babyinfopage.dart';
import 'package:baby_tracker/pages/detailspages.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BabyCard extends StatefulWidget {
  const BabyCard({
    super.key,
    required this.babyName,
    required this.babyId,
    required this.userName,
  });
  final String babyName;
  final String babyId;
  final String userName;

  @override
  State<BabyCard> createState() => _BabyCardState();
}

class _BabyCardState extends State<BabyCard> {
  String babyTheme = "";
  String gender = "";
  Stream<QuerySnapshot>? events;

  @override
  void initState() {
    getThemeandGender();
    super.initState();
    getEventData();
  }

  getEventData() {
    DatabaseService().getEventData(widget.babyId).then((val) {
      setState(() {
        events = val;
      });
    });
  }

  getThemeandGender() {
    DatabaseService().getBabyTheme(widget.babyId).then((val) {
      setState(() {
        babyTheme = val;
      });
    });
    DatabaseService().getBabyGender(widget.babyId).then((val) {
      setState(() {
        gender = val;
      });
    });
  }

  colorGradient() {
    if (babyTheme == 'red') {
      return LinearGradient(
        colors: const [AppColorScheme.red, AppColorScheme.paleRed],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (babyTheme == 'blue') {
      return LinearGradient(
        colors: const [AppColorScheme.blue, AppColorScheme.paleBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (babyTheme == 'yellow') {
      return LinearGradient(
        colors: const [AppColorScheme.paleYellow, AppColorScheme.yellow],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (babyTheme == 'green') {
      return LinearGradient(
        colors: const [AppColorScheme.green, AppColorScheme.paleGreen],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return LinearGradient(
        colors: const [AppColorScheme.lightGray, AppColorScheme.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  babyGender() {
    if (gender == 'Male') {
      return Container(
          // if male then color = blue
          color: AppColorScheme.paleBlue,
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.child_care, size: 30));
    } else {
      return Container(
          color: AppColorScheme.palePink, // if female
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.child_care, size: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsPages(
                      userName: widget.userName,
                      babyName: widget.babyName,
                      babyId: widget.babyId,
                      theme: babyTheme,
                    )));
      },
      onLongPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BabyInfoPage(
                    babyName: widget.babyName,
                    babyId: widget.babyId,
                    userName: widget.userName)));
      },
      child: Container(
          margin: const EdgeInsets.all(20),
          height: 150,
          decoration: BoxDecoration(
            gradient: colorGradient(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: [
                  ClipOval(child: babyGender()),
                  const SizedBox(width: 20),
                  Text(style: TextStyle(fontSize: 48), widget.babyName),
                  SizedBox(
                    width: 50,
                  ),
                ]),
              )
            ],
          )),
    );
  }
}
