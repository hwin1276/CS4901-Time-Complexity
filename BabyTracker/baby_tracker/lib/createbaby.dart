import 'package:flutter/material.dart';

class CreateBaby extends StatefulWidget {
  const CreateBaby({Key? key}) : super(key: key);

  @override
  State<CreateBaby> createState() => _CreateBabyState();
}

class _CreateBabyState extends State<CreateBaby> {
  String? gender;
  DateTime date = DateTime(2022, 11, 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Baby Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Baby Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Name",
                ),
              ),
            ),
            // Baby Gender
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    RadioListTile(
                      title: Text("Male"),
                      value: "male",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Female"),
                      value: "female",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Other"),
                      value: "other",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    )
                  ],
                )),
            // Baby Birth Date
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Birth Date:'),
                  Text(
                    '${date.month}/${date.day}/${date.year}',
                    style: TextStyle(fontSize: 32),
                  ),
                  ElevatedButton(
                    child: Text('Select Date'),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2018),
                          lastDate: DateTime(2100));
                      // if 'CANCEL'
                      if (newDate == null) return;
                      // if 'OK'
                      setState(() => date = newDate);
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
                  onPressed: () {},
                  child: const Text('Confirm',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
