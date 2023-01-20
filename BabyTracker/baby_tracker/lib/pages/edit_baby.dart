import 'package:flutter/material.dart';
import 'package:baby_tracker/helper/helper_functions.dart';
import 'package:baby_tracker/service/auth_service.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Edit extends StatefulWidget {
  const Edit({
    Key? key,
    required this.babyId,
  }) : super(key: key);
  final String babyId;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final formKey = GlobalKey<FormState>();
  String babyName = "";
  String userName = "";
  String theme = "";
  String email = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  getTheme() {
    DatabaseService().getBabyTheme(widget.babyId).then((val) {
      setState(() {
        theme = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // Account Settings
            SizedBox(height: 40),
            Row(
              children: const [
                Icon(Icons.child_care, color: Colors.blue),
                SizedBox(width: 10),
                Text("Details", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(
              height: 20,
              thickness: 1,
            ),
            // Baby Theme
            SizedBox(height: 40),
            Row(
              children: const [
                Icon(Icons.palette, color: Colors.blue),
                SizedBox(width: 10),
                Text("Theme", style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Divider(
              height: 20,
              thickness: 1,
            ),
            SizedBox(height: 10),
            FormField(
              builder: (state) {
                return Column(
                  children: [
                    RadioListTile<String>(
                        title: Text('Red'),
                        value: 'red',
                        groupValue: theme,
                        onChanged: (String? value) {
                          setState(() {
                            theme = value!;
                          });
                        }),
                    RadioListTile<String>(
                        title: Text('Blue'),
                        value: 'blue',
                        groupValue: theme,
                        onChanged: (String? value) {
                          setState(() {
                            theme = value!;
                          });
                        }),
                    RadioListTile<String>(
                        title: Text('Green'),
                        value: 'green',
                        groupValue: theme,
                        onChanged: (String? value) {
                          setState(() {
                            theme = value!;
                          });
                        }),
                    RadioListTile<String>(
                        title: Text('Yellow'),
                        value: 'yellow',
                        groupValue: theme,
                        onChanged: (String? value) {
                          setState(() {
                            theme = value!;
                          });
                        }),
                    Text(
                      state.errorText ?? '',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  ],
                );
              },
            ),
            SizedBox(height: 60),
            TextButton.icon(
              onPressed: () async {
                editBaby();
              },
              icon: Icon(Icons.check),
              label: const Text(
                'Save Changes',
              ),
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  editBaby() async {
    if (formKey.currentState!.validate()) {
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .editBaby(FirebaseAuth.instance.currentUser!.uid, theme);
      Navigator.of(context).pop();
      showSnackBar(context, Colors.green, "Baby edited successfully");
    }
  }
}
