import 'package:baby_tracker/widgets/textInputDecoration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'loginpage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String userName = "";
  String password = "";
  bool _isLoading = false;
  //AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register Page'),
        ),
        body: SingleChildScrollView(
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
                              color: Colors.pink,
                              alignment: Alignment.center,
                              child: const Text(
                                  'logo',
                                  style: TextStyle(
                                      color: Colors.black
                                  )
                              ),
                            )
                        ),
                        const SizedBox(height:5),
                        const Text(
                            'BabyTracker',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                        const SizedBox(height: 5),
                        const Text(
                            'Developed by: Kennedy Middlebrooks, \nHung Nguyen, Cecil Nnodim, Hien Pham',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 9
                            )
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
                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!) ? null : "Please enter a valid email";
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: "Username",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                userName = val;
                              });
                            },
                            validator: (val) {
                              if(val!.isNotEmpty) {
                                return null;
                              }
                              else {
                                return "Username cannot be empty";
                              }
                            },
                          ),
                        ),
                        const SizedBox(height:10),
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
                              if(val!.length < 6) {
                                return "Password must be atleast 6 characters";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(height:20),
                        Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextButton(
                              onPressed: () {
                                register();
                              },
                              child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )
                              ),
                            )
                        ),
                        SizedBox(height: 10),
                        Text.rich(
                            TextSpan(
                                text: "Already have an account?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Login now",
                                    style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LoginPage()
                                          )
                                      );
                                    },
                                  ),
                                ]
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }

  register() {

  }
}
