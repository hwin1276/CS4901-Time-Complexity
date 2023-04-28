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

  fillAlertList(AsyncSnapshot snapshot) async {
    alerts.clear();
    //alert string form is "status_userid_username_babyid_babyname"
    for (int i = 0; i < snapshot.data["alert"].length; i++) {
      String alertString = snapshot.data["alert"][i];
      List<String> splitString = alertString.split("_");

      alerts.add(AlertData(splitString[0], splitString[1], splitString[2],
          splitString[3], splitString[4]));
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
              status: alerts[index].status,
              userId: alerts[index].userId,
              userName: alerts[index].userName,
              babyId: alerts[index].babyId,
              babyName: alerts[index].babyName);
        });
  }
}

class AlertData {
  String status;
  String userId;
  String userName;
  String babyId;
  String babyName;

  AlertData(
      this.status, this.userId, this.userName, this.babyId, this.babyName);
}
