import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection = FirebaseFirestore.instance.collection(
      "users"); // if exists enters collections otherwise firebase creates it for us
  final CollectionReference babyCollection =
      FirebaseFirestore.instance.collection("babies");

  // updating the user data
  Future updateUserData(String userName, String email) async {
    return await userCollection.doc(uid).set({
      "userName": userName,
      "email": email,
      "babies": [],
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user babies
  getUserBabies() async {
    return userCollection.doc(uid).snapshots();
  }

  // get baby theme
  Future getBabyTheme(String babyId) async {
    DocumentReference d = babyCollection.doc(babyId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['theme'];
  }

  // get baby gender
  Future getBabyGender(String babyId) async {
    DocumentReference d = babyCollection.doc(babyId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['gender'];
  }

  // get baby birthdate
  Future getBabyBirthdate(String babyId) async {
    DocumentReference d = babyCollection.doc(babyId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['birthDate'];
  }

  // get event data
  getEventData(String babyId) async {
    return babyCollection
        .doc(babyId)
        .collection("events")
        .orderBy("startTime", descending: true)
        .snapshots();
  }

  // Edit user

  // get baby admin
  getBabyAdmin(String babyId) async {
    DocumentReference d = babyCollection.doc(babyId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get baby caretakers
  getBabyCaretakers(String babyId) async {
    DocumentReference d = babyCollection.doc(babyId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['caretakers'];
  }

  // search for users
  searchByUserName(String userName) {
    return userCollection.where("userName", isEqualTo: userName).get();
  }

  // check whether a user is a caretaker for a baby
  Future<bool> isUserCaretaker(String userName, String searchUserName,
      String searchEmail, babyName, babyId) async {
    String searchUID = "M7EMJcNStcQYNoq6YlyVWOyxImk1";
    /*
    Map<String, dynamic> map = {};
    var document =
        await userCollection.where("email", isEqualTo: searchEmail).get();
    document.docs.forEach((element) {
      map = element as Map<String, dynamic>;
    });
    */
    var document =
        await userCollection.where("email", isEqualTo: searchEmail).get();
    var data = Map<String, dynamic>.from(document.docs[0].data() as Map);

    DocumentReference userDocumentReference = userCollection.doc(data['uid']);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> babies = await documentSnapshot['babies'];
    if (babies.contains("${babyId}_$babyName")) {
      return true;
    } else {
      return false;
    }
  }

  // creating a baby
  Future createBaby(String userName, String id, String babyName, String gender,
      String theme, DateTime birthDate) async {
    DocumentReference babyDocumentReference = await babyCollection.add({
      "babyName": babyName,
      "admin": "${id}_$userName",
      "gender": gender,
      "theme": theme,
      "birthDate": birthDate,
      "caretakers": [],
      "babyId": "",
    });

    // update the members
    await babyDocumentReference.update({
      "caretakers": FieldValue.arrayUnion(["${uid}_$userName"]),
      "babyId": babyDocumentReference.id,
    });
    DocumentReference userDocumentReference = await userCollection.doc(uid);
    return await userDocumentReference.update({
      "babies": FieldValue.arrayUnion(["${babyDocumentReference.id}_$babyName"])
    });
  }

  // create an event
  createEvent(String babyId, Map<String, dynamic> eventData) async {
    babyCollection.doc(babyId).collection("events").add(eventData);
  }
}
