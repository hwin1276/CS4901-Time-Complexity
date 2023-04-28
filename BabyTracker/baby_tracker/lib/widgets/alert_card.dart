import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  const AlertCard(
      {Key? key,
      required this.status,
      required this.userId,
      required this.userName,
      required this.babyId,
      required this.babyName})
      : super(key: key);

  final String status;
  final String userId;
  final String userName;
  final String babyId;
  final String babyName;

  textOutput() {
    if (status == "received") {
      return "$userName has invited you to help take care of $babyName";
    } else if (status == "accepted") {
      return "$userName has accepted your invitation to help take care of $babyName";
    } else {
      return "$userName has declined your invitation to help take care of $babyName";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: AppColorScheme.white,
        title: Text(textOutput(),
            style: AppTextTheme.body.copyWith(
              color: AppColorScheme.black,
            )),
        trailing: response(context),
      ),
    );
  }

  response(BuildContext context) {
    if (status == "received") {
      return Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: EdgeInsets.all(0),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: AppColorScheme.green,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: AppColorScheme.white,
            iconSize: 18,
            icon: Icon(Icons.check_box),
            onPressed: () {
              DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .acceptInvite(babyId, userId);
              DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .removeAlert(
                      "${status}_${userId}_${userName}_${babyId}_$babyName");
              showSnackBar(
                  context, Colors.green, "You are now caring for $babyName");
            },
          ),
        ),
        SizedBox(width: 10),
        Container(
          padding: EdgeInsets.all(0),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: AppColorScheme.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: AppColorScheme.white,
            iconSize: 18,
            icon: Icon(Icons.clear_rounded),
            onPressed: () {
              DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .declineInvite(babyId, userId);
              showSnackBar(context, Colors.red, "Declining invitation");
            },
          ),
        ),
      ]);
    } else {
      return Container(
        padding: EdgeInsets.all(0),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: AppColorScheme.red,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          color: AppColorScheme.white,
          iconSize: 18,
          icon: Icon(Icons.delete),
          onPressed: () {
            DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .removeAlert(
                    "${status}_${userId}_${userName}_${babyId}_$babyName");
            showSnackBar(context, Colors.red, "Removing alert");
          },
        ),
      );
    }
  }
}
