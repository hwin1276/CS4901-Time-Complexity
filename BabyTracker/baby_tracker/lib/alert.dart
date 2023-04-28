import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/alert_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Alert extends StatefulWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  Stream? userData;
  final List<AlertData> alerts = <AlertData>[];

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

  fillAlertList(AsyncSnapshot snapshot) {
    alerts.clear();
    //alert string form is "status_user_baby"
    for (int i = 0; i < snapshot.data["alert"].length; i++) {
      String alertString = snapshot.data["alert"][i];
      String userbabyString =
          alertString.substring(alertString.indexOf("_") + 1);
      String statusString = alertString.substring(0, alertString.indexOf("_"));
      String userString =
          userbabyString.substring(0, userbabyString.indexOf("_"));
      String babyString =
          userbabyString.substring(userbabyString.indexOf("_") + 1);
      alerts.add(AlertData(babyString, userString, statusString));
    }
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
                        fillAlertList(snapshot);
                        return alertList();
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

  alertList() {
    return ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          return AlertCard(
              babyName: alerts[index].babyName,
              userName: alerts[index].userName,
              status: alerts[index].status);
        });
  }
}

class AlertData {
  String babyName;
  String userName;
  String status;

  AlertData(this.babyName, this.userName, this.status);
}
