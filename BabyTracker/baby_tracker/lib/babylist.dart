import 'package:flutter/material.dart';

class BabyList extends StatefulWidget {
  const BabyList({Key? key}) : super(key: key);

  @override
  State<BabyList> createState() => _BabyListState();
}

class _BabyListState extends State<BabyList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Baby View'),
          centerTitle: true,
        ),
        body: Center(
            child: Text(
                'Baby View to be Added'
            )
        )
    );
  }
}
