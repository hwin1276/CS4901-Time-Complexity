import 'package:flutter/material.dart';
import 'Models/events.dart';
import 'home.dart';
import 'db/sqlite.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late List<Event> events;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshEvents();
  }

  @override
  void dispose() {
    SqliteDB.instance.close();
    super.dispose();
  }

  Future refreshEvents() async {
    setState(() => isLoading = true);
    this.events = await SqliteDB.instance.readAllEvents();
    setState(() => isLoading = false);
  }

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
// this is temp view for understanding how events are being populated
   Widget buildEvents() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: events.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final event = events[index];

          // the following calls on event input page. blurred out for now.

          return GestureDetector(
            onTap: () async {
             // await Navigator.of(context).push(MaterialPageRoute(
               // builder: (context) => NoteDetailPage(noteId: note.id!),
           //   ));

              refreshEvents();
            },
           // child: EventCardWidget(note: note, index: index),
          );
        },
      );
}
