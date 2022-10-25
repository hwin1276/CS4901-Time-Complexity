import 'package:flutter/material.dart';
import 'package:baby_tracker/objects/baby.dart';

class BabyCard extends StatelessWidget {

  final Baby baby;
  final Function() toDetails;
  const BabyCard( {super.key, required this.baby, required this.toDetails});


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0,16.0,16.0,0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              baby.name,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 6.0),
            ElevatedButton.icon(
              onPressed: toDetails,
              label: const Text('View Details'),
              icon: const Icon(Icons.child_care),
            ),
          ],
        ),
      )
    );
  }
}
