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
                              color: AppColorScheme.lightGray,
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
                      // Baby Gender
                      // Padding(
                      //     padding: EdgeInsets.symmetric(horizontal: 15),
                      //     child: Column(
                      //       children: [
                      //         RadioListTile(
                      //           title: Text("Male"),
                      //           value: "male",
                      //           groupValue: gender,
                      //           onChanged: (value) {
                      //             setState(() {
                      //               gender = value.toString();
                      //             });
                      //           },
                      //         ),
                      //         RadioListTile(
                      //           title: Text("Female"),
                      //           value: "female",
                      //           groupValue: gender,
                      //           onChanged: (value) {
                      //             setState(() {
                      //               gender = value.toString();
                      //             });
                      //           },
                      //         ),
                      //         RadioListTile(
                      //           title: Text("Other"),
                      //           value: "other",
                      //           groupValue: gender,
                      //           onChanged: (value) {
                      //             setState(() {
                      //               gender = value.toString();
                      //             });
                      //           },
                      //         )
                      //       ],
                      //     )),
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
                                color: AppColorScheme.white,
                              ),
                            ),
                            ElevatedButton(
                              child: Text('Select Date'),
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: birthDate,
                                    firstDate: DateTime(2018),
                                    lastDate: DateTime(2100));
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
                              color: AppColorScheme.white,
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
              babyName, gender, birthDate)
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
