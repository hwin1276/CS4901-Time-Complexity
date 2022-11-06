import 'package:flutter/material.dart';

import 'home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email'
                      ),
                    ),
                  ),
                  const SizedBox(height:10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal:15),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      )
                    )
                  ),
                  TextButton(
                    onPressed: () {
                      ///TODO Make Forgot Password Screen
                    },
                    child: const Text('Forgot Password')
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const Home()
                          )
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        )
                      ),
                    )
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}
