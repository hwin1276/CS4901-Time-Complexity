import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Alert extends StatefulWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  Stream? userData;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserData()
        .then((snapshot) {
      setState(() {
        userData = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Alerts'),
          centerTitle: true,
        ),
        body: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: userData,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Center(child: Text("data"));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'No data available right now',
                            style: AppTextTheme.body.copyWith(
                              color: AppColorScheme.white,
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColorScheme.white,
                          ),
                        );
                      }
                    }),
              )
            ],
          ),
        ));
  }
}
