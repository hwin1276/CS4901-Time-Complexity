import 'package:baby_tracker/helper/helper_functions.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/showsnackbar.dart';

class AddCaretaker extends StatefulWidget {
  const AddCaretaker({Key? key, required this.babyName, required this.babyId})
      : super(key: key);
  final String babyName;
  final String babyId;

  @override
  State<AddCaretaker> createState() => _AddCaretakerState();
}

class _AddCaretakerState extends State<AddCaretaker> {
  TextEditingController searchController = TextEditingController();
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  bool _isLoading = false;
  bool isJoined = false;
  String userName = "";
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add a Caretaker",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.purple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                "Search for another user using their username...",
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 16),
                          )),
                    ),
                    GestureDetector(
                        onTap: () {
                          initiateSearchMethod();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : userList()
            ],
          ),
        ));
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searchByUserName(searchController.text)
          .then((snapshot) {
        setState(() {
          if (snapshot.docs.length == 0) {
            showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(title: Text("No one found by that username")),
            );
          } else {
            searchSnapshot = snapshot;
            hasUserSearched = true;
          }
          _isLoading = false;
        });
      });
    }
  }

  userList() {
    //return Container();
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return userTile(
                userName,
                searchSnapshot!.docs[index]['userName'],
                searchSnapshot!.docs[index]['email'],
              );
            },
          )
        : Container(child: Text("Search for a user"));
  }

  alreadyCaretaker(
      String userName, String searchUsername, String searchEmail) async {
    await DatabaseService(uid: user!.uid)
        .isUserCaretaker(userName, searchUsername, searchEmail, widget.babyName,
            widget.babyId)
        .then((value) {
      if (mounted) {
        setState(() {
          isJoined = value;
        });
      }
    });
  }

  Widget userTile(String userName, String searchUsername, String searchEmail) {
    alreadyCaretaker(userName, searchUsername, searchEmail);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          widget.babyName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(searchUsername,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Email: $searchEmail"),
      trailing: InkWell(
          onTap: () async {
            if (!isJoined) {
              await DatabaseService(uid: user!.uid).inviteUser(
                  widget.babyId, widget.babyName, searchEmail, searchUsername);
              setState(() {
                isJoined = !isJoined;
              });
              showSnackBar(
                  context, Colors.green, "Succssfully invited $searchUsername");
            } else {
              showSnackBar(
                  context, Colors.red, "You have already invited this person");
            }
          },
          child: isJoined
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text("Invited",
                      style: TextStyle(color: Colors.white)))
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text("Invite",
                      style: TextStyle(color: Colors.white)))),
    );
  }
}
