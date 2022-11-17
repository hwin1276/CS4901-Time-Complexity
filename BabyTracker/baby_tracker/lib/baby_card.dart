import 'package:flutter/material.dart';
import 'package:baby_tracker/objects/baby.dart';

class BabyCard extends StatelessWidget {
  BabyCard({super.key, required this.baby, required this.onClick()});
  Function onClick;
  final Baby baby;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
          margin: const EdgeInsets.all(20),
          height: 150,
          decoration: const BoxDecoration(color: Colors.grey),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: [
                  ClipOval(
                    child: Container(
                        color: Colors.blue[100],
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.child_care, size: 30)),
                  ),
                  const SizedBox(width: 10),
                  Text(baby.name),
                ]),
              )
            ],
          )),
    );
  }
}
