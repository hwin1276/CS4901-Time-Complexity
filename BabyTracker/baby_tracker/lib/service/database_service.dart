import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users"); // if exists enters collections otherwise firebase creates it for us
  final CollectionReference babyCollection = FirebaseFirestore.instance.collection("babies");

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
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
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

  // creating a baby
  Future createBaby(String userName, String id, String babyName, String gender, DateTime birthDate) async{
    DocumentReference babyDocumentReference = await babyCollection.add({
      "babyName": babyName,
      "admin": "${id}_$userName",
      "gender": gender,
      "theme": "blue",
      "birthDate": birthDate,
      "caretakers": [],
      "events": [],
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
}