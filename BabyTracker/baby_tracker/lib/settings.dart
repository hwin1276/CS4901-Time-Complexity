import 'package:baby_tracker/loginpage.dart';
import 'package:baby_tracker/objects/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

// Account settings
GestureDetector buildAccount(BuildContext context, String title) {
  return GestureDetector(
      onTap: () {},
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey)),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[600])
            ],
          )));
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // Account Settings
            SizedBox(height: 40),
            Row(
              children: const [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 10),
                Text("Account", style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Divider(
              height: 20,
              thickness: 1,
            ),
            SizedBox(height: 10),
            buildAccount(context, "Change Password"),
            buildAccount(context, "Manage Shared Users"),
            buildAccount(context, "Privacy and Security"),
            // Accessiblity Settings
            SizedBox(height: 40),
            Row(
              children: const [
                Icon(Icons.accessibility, color: Colors.blue),
                SizedBox(width: 10),
                Text("Accessibility",
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Divider(
              height: 20,
              thickness: 1,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Dark Mode'),
                CupertinoSwitch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      final provider =
                          Provider.of<ThemeProvider>(context, listen: false);
                      provider.toggleTheme(value);
                    }),
              ],
            ),
            // Sign Out
            SizedBox(height: 80),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 170, 168, 168),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                icon: Icon(Icons.logout),
                label: const Text('Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
