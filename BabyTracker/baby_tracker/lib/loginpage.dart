import 'package:baby_tracker/helper/helper_functions.dart';
import 'package:baby_tracker/home.dart';
import 'package:baby_tracker/registerpage.dart';
import 'package:baby_tracker/service/auth_service.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:baby_tracker/widgets/textInputDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              )
            : SingleChildScrollView(
                child: Stack(
                children: [
                  Form(
                    key: formKey,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                              child: Container(
                            width: 150,
                            height: 150,
                            color: AppColorScheme.pink,
                            alignment: Alignment.center,
                            child: const Text(
                              'logo',
                              style: TextStyle(color: AppColorScheme.black),
                            ),
                          )),
                          const SizedBox(height: 5),
                          const Text('BabyTracker',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColorScheme.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 5),
                          const Text(
                            'Developed by: Kennedy Middlebrooks, April Eaton,\nColin McCrory, Hung Nguyen, Cecil Nnodim, Hien Pham',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColorScheme.lightGray, fontSize: 9),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              decoration: textInputDecoration.copyWith(
                                labelText: "Email",
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Please enter a valid email";
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                labelText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "Password must be atleast 6 characters";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                ///TODO Make Forgot Password Screen
                              },
                              child: const Text('Forgot Password')),
                          Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                color: AppColorScheme.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  login();
                                },
                                child: const Text('Login',
                                    style: TextStyle(
                                      color: AppColorScheme.white,
                                    )),
                              )),
                          SizedBox(height: 10),
                          Text.rich(TextSpan(
                              text: "Don't have an account?",
                              style: TextStyle(
                                color: AppColorScheme.black,
                                fontSize: 14,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Register here",
                                  style: TextStyle(
                                    color: AppColorScheme.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterPage()));
                                    },
                                ),
                              ])),
                        ],
                      ),
                    ),
                  ),
                ],
              )));
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          // saving the shared preferences state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['userName']);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Home()));
        } else {
          showSnackBar(context, AppColorScheme.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
// this is temp view for understanding how events are being populated
//  //  Widget buildEvents() => StaggeredGridView.countBuilder(
//         padding: EdgeInsets.all(8),
//         itemCount: events.length,
//         staggeredTileBuilder: (index) => StaggeredTile.fit(2),
//         crossAxisCount: 4,
//         mainAxisSpacing: 4,
//         crossAxisSpacing: 4,
//         itemBuilder: (context, index) {
//           final event = events[index];

//           // the following calls on event input page. blurred out for now.

//           return GestureDetector(
//             onTap: () async {
//              // await Navigator.of(context).push(MaterialPageRoute(
//                // builder: (context) => NoteDetailPage(noteId: note.id!),
//            //   ));

//               refreshEvents();
//             },
//            // child: EventCardWidget(note: note, index: index),
//           );
//         },
//       );
}
