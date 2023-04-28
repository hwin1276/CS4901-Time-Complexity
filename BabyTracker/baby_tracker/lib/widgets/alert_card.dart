import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  const AlertCard(
      {Key? key,
      required this.babyName,
      required this.userName,
      required this.status})
      : super(key: key);

  final String babyName;
  final String userName;
  final String status;

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
        trailing: response(),
      ),
    );
  }

  response() {
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
            onPressed: () {},
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
            onPressed: () {},
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
          onPressed: () {},
        ),
      );
    }
  }
}
