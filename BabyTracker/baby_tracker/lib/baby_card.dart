import 'package:baby_tracker/pages/detailspages.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/objects/baby.dart';

class BabyCard extends StatefulWidget {
  BabyCard({super.key,
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

  @override
  void initState() {
    getThemeandGender();
    super.initState();
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
        colors: const [Color(0xfff32e20), Color(0xffee4c83)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (babyTheme == 'blue') {
      return LinearGradient(
        colors: const [Color(0xff2095f3), Color(0xffb5dcfb)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (babyTheme == 'yellow') {
      return LinearGradient(
        colors: const [Color(0xfffff389), Color(0xffffa014)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (babyTheme == 'green') {
      return LinearGradient(
        colors: const [Color(0xff47a44b), Color(0xffaddbaf)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return LinearGradient(
        colors: const [Color(0xffb9b9b9), Color(0xffffffff)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  babyGender() {
    if (gender == 'Male') {
      return Container(
          // if male then color = blue
          color: Colors.blue[100],
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.child_care, size: 30));
    } else {
      return Container(
          color: Colors.pink[100], // if female
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
                builder: (context) => DetailsPages(text: widget.babyName)
            )
        );
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
                  const SizedBox(width: 10),
                  Text(widget.babyName),
                ]),
              )
            ],
          )),
    );
  }
}
