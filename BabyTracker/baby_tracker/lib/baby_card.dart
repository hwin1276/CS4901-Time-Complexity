import 'package:flutter/material.dart';
import 'package:baby_tracker/objects/baby.dart';

class BabyCard extends StatelessWidget {
  BabyCard({super.key, required this.baby, required this.onClick()});
  Function onClick;
  final Baby baby;

  colorGradient() {
    if (baby.theme == 'red') {
      return LinearGradient(
        colors: const [Color(0xfff32e20), Color(0xffee4c83)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (baby.theme == 'blue') {
      return LinearGradient(
        colors: const [Color(0xff2095f3), Color(0xffb5dcfb)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (baby.theme == 'yellow') {
      return LinearGradient(
        colors: const [Color(0xfffff389), Color(0xffffa014)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (baby.theme == 'green') {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
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
                  ClipOval(
                      child: baby.gender
                          ? Container(
                              // if male then color = blue
                              color: Colors.blue[100],
                              padding: const EdgeInsets.all(10),
                              child: const Icon(Icons.child_care, size: 30))
                          : Container(
                              color: Colors.pink[100], // if female
                              padding: const EdgeInsets.all(10),
                              child: const Icon(Icons.child_care, size: 30))),
                  const SizedBox(width: 10),
                  Text(baby.name),
                ]),
              )
            ],
          )),
    );
  }
}
