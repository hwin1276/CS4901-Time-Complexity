import 'package:baby_tracker/helper/helper_functions.dart';
import 'package:baby_tracker/home.dart';
import 'package:baby_tracker/registerpage.dart';
import 'package:baby_tracker/service/auth_service.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:baby_tracker/widgets/textInputDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String validEmailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: Image.asset('assets/logo.png'),
                          ),
                          const SizedBox(height: 5),
                          credits(),
                          const SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              decoration: textInputDecoration.copyWith(
                                labelText: "Email",
                                prefixIcon: Icon(
                                  Icons.email,
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              validator: (val) {
                                return RegExp(validEmailRegex).hasMatch(val!)
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
                                ),
                              ),
                              onChanged: (val) {
                                setState(
                                  () {
                                    password = val;
                                  },
                                );
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
                              child: Text(
                                'Login',
                                style: AppTextTheme.h2.copyWith(
                                  color: AppColorScheme.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              text: "Don't have an account?",
                              style: AppTextTheme.body.copyWith(
                                color: AppColorScheme.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: " Register here",
                                  style: AppTextTheme.body.copyWith(
                                    color: AppColorScheme.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Text credits() {
    String developers =
        'Developed by: Kennedy Middlebrooks, April Eaton,\nColin McCrory, Hung Nguyen, Cecil Nnodim, Hien Pham';
    return Text(
      developers,
      textAlign: TextAlign.center,
      style: AppTextTheme.subtitle.copyWith(
        color: AppColorScheme.white,
        fontSize: 9,
      ),
    );
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
}
