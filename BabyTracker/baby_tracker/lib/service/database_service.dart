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

  // get event data
  getEventData(String babyId) async {
    return babyCollection.doc(babyId).collection("events").snapshots();
  }

  // Edit user

  // Edit baby
  Future editBaby(String userName, String id, String babyName, String gender,
      String theme, DateTime birthDate) async {}

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
