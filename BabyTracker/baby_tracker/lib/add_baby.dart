import 'package:flutter/material.dart';

class AddBaby extends StatelessWidget {
  const AddBaby({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.fromLTRB(16.0,16.0,16.0,0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        )
    );
  }
}
