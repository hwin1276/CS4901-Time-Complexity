import 'package:baby_tracker/home.dart';
import 'package:baby_tracker/loginpage.dart';
import 'package:baby_tracker/service/auth_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:baby_tracker/widgets/textInputDecoration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'helper/helper_functions.dart';

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
  String validEmailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register Page',
          style: AppTextTheme.h1.copyWith(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 20,
          ),
        ),
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
                                labelStyle: AppTextTheme.h2.copyWith(
                                  color: AppColorScheme.lightGray
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: AppColorScheme.lightGray,
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
                              decoration: textInputDecoration.copyWith(
                                labelText: "Username",
                                labelStyle: AppTextTheme.h2.copyWith(
                                  color: AppColorScheme.lightGray
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: AppColorScheme.lightGray,
                                ),
                              ),
                              onChanged: (val) {
                                setState(
                                  () {
                                    userName = val;
                                  },
                                );
                              },
                              validator: (val) {
                                if (val!.isNotEmpty) {
                                  return null;
                                } else {
                                  return "Username cannot be empty";
                                }
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
                                labelStyle: AppTextTheme.h2.copyWith(
                                  color: AppColorScheme.lightGray
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: AppColorScheme.lightGray,
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
                          const SizedBox(height: 20),
                          Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                              color: AppColorScheme.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextButton(
                              onPressed: () {
                                register();
                              },
                              child: Text(
                                'Register',
                                style: AppTextTheme.body.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              text: "Already have an account?",
                              style: AppTextTheme.body.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Login now",
                                  style: AppTextTheme.body.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
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
        color: Theme.of(context).textTheme.bodySmall?.color,
        fontSize: 9,
      ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(userName, email, password)
          .then(
        (value) async {
          if (value == true) {
            // saving the shared preference state
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserEmailSF(email);
            await HelperFunctions.saveUserNameSF(userName);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          } else {
            showSnackBar(context, AppColorScheme.red, value);
            setState(
              () {
                _isLoading = false;
              },
            );
          }
        },
      );
    }
  }
}
