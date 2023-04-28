import 'package:baby_tracker/helper/helper_functions.dart';
import 'package:baby_tracker/service/auth_service.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateBaby extends StatefulWidget {
  const CreateBaby({Key? key}) : super(key: key);

  @override
  State<CreateBaby> createState() => _CreateBabyState();
}

class _CreateBabyState extends State<CreateBaby> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String babyName = "";
  String gender = "";
  String theme = "";
  String userName = "";
  String email = "";
  DateTime birthDate = DateTime.now();
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
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Baby Profile'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Baby Name
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: AppTextTheme.subtitle.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                          onChanged: (val) {
                            setState(
                              () {
                                babyName = val;
                              },
                            );
                          },
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be empty";
                            }
                          },
                        ),
                      ),
                      // Gender
                      Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      Row(
                        children: const [
                          SizedBox(width: 10),
                          Text("Gender",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                      FormField(
                        builder: (state) {
                          return Column(
                            children: [
                              RadioListTile<String>(
                                title: Text('Male'),
                                value: 'Male',
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(
                                    () {
                                      gender = value!;
                                    },
                                  );
                                },
                              ),
                              RadioListTile<String>(
                                title: Text('Female'),
                                value: 'Female',
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(
                                    () {
                                      gender = value!;
                                    },
                                  );
                                },
                              ),
                              RadioListTile<String>(
                                title: Text('Other'),
                                value: 'Other',
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(
                                    () {
                                      gender = value!;
                                    },
                                  );
                                },
                              ),
                              Text(
                                state.errorText ?? '',
                                style: TextStyle(
                                  color: AppColorScheme.red,
                                ),
                              )
                            ],
                          );
                        },
                        validator: (value) {
                          if (gender == "") return "Please select a gender";
                          return null;
                        },
                      ),
                      Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      // Baby Theme (color of the card)
                      Row(
                        children: const [
                          SizedBox(width: 10),
                          Text("Theme",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
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
                        validator: (value) {
                          if (theme == "") return "Please select a theme";
                          return null;
                        },
                      ),
                      Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      // Baby Birth Date
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Birth Date:'),
                            Text(
                              '${birthDate.month}/${birthDate.day}/${birthDate.year}',
                              style: AppTextTheme.h2.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.color,
                              ),
                            ),
                            ElevatedButton(
                              child: Text('Select Date'),
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: birthDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now());
                                // if 'CANCEL'
                                if (newDate == null) return;
                                // if 'OK'
                                setState(() => birthDate = newDate);
                              },
                            )
                          ],
                        ),
                      ),
                      /*$Divider(
                  color: Colors.grey,
                ),*/
                      SizedBox(height: 100),
                      // Confirm button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                      Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            createBaby();
                          },
                          child: Text(
                            'Confirm',
                            style: AppTextTheme.body.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  createBaby() async {
    if (formKey.currentState!.validate()) {
      setState(
        () {
          _isLoading = true;
        },
      );
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .createBaby(userName, FirebaseAuth.instance.currentUser!.uid,
              babyName, gender, theme, birthDate)
          .whenComplete(
        () {
          _isLoading = false;
        },
      );
      Navigator.of(context).pop();
      showSnackBar(context, AppColorScheme.green, "Baby added successfully");
    }
  }
}
