import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      "alert": [],
      "uid": uid,
    });
  }

  // getting user data NOTE:Returns QuerySnapshot
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user data
  Future getUserData() async {
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

  // get all event data
  Future getEventData(String babyId) async {
    return babyCollection
        .doc(babyId)
        .collection("events")
        .orderBy("startTime", descending: true)
        .snapshots();
  }

  // get specific event data
  Future getSpecificEventData(String eventId, String babyId) async {
    return babyCollection.doc(babyId).collection("events").doc(eventId).get();
  }

  // function for getFutureEvent. Searches through babies and gets event id
  Future<void> getEventBabyId(Map<String, String> eventidBabyid,
      QuerySnapshot babiesWithFutureEvents) async {
    //Map<String, String> eventidBabyid = {};
    for (var babySnapshot in babiesWithFutureEvents.docs) {
      QuerySnapshot eventQuery =
          await babyCollection.doc(babySnapshot.id).collection("events").get();
      await getEventId(eventidBabyid, eventQuery, babySnapshot.id);
    }
  }

  // set eventid as key and babyit as value
  Future<void> getEventId(Map<String, String> eventidBabyid,
      QuerySnapshot eventQuery, babySnapshotId) async {
    for (var eventSnapshot in eventQuery.docs) {
      if (eventSnapshot["completed"] == false) {
        eventidBabyid[eventSnapshot.id] = babySnapshotId;
      }
    }
  }

  // get baby id and their incomplete future tasks
  Future getFutureEvent(String userId, String userName) async {
    // get baby data with future events
    QuerySnapshot babiesWithFutureEvents = await babyCollection
        .where("caretakers", arrayContains: "${userId}_$userName")
        .where("incompleteEvents", isNotEqualTo: []).get();

    // gets a map of baby id and event ids
    Map<String, String> eventidBabyid = {};
    await getEventBabyId(eventidBabyid, babiesWithFutureEvents);

    return eventidBabyid;
  }

  // set event as completed
  setTaskStatus(String eventId, String babyId, bool status) async {
    babyCollection
        .doc(babyId)
        .collection("events")
        .doc(eventId)
        .update({"completed": status});
  }

  // remove event from incomplete task list
  finishTask(String eventId, String babyId) async {
    babyCollection.doc(babyId).update({
      "incompleteEvents": FieldValue.arrayRemove(["${eventId}_$babyId"])
    });
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

  // check whether a user is a caretaker for a baby using a caretaker's email
  Future<bool> isUserCaretakerWithEmail(
      String searchEmail, babyName, babyId) async {
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

  // check whether a user is a caretaker for a baby using a caretaker's id
  Future<bool> isUserCaretakerWithId(String searchId, babyName, babyId) async {
    DocumentReference userDocumentReference = userCollection.doc(searchId);
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
      "incompleteEvents": [],
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
  Future createEvent(String babyId, Map<String, dynamic> eventData) async {
    DocumentReference eventDocumentReference =
        await babyCollection.doc(babyId).collection("events").add(eventData);
    if (eventData["type"] == "Appointments") {
      DocumentReference babyDocumentReference = babyCollection.doc(babyId);
      babyDocumentReference.update({
        "incompleteEvents":
            FieldValue.arrayUnion(["${eventDocumentReference.id}_$babyId"])
      });
    }
  }

  // edit an event
  Future editEvent(
      String babyId, String eventId, Map<String, dynamic> eventData) async {
    DocumentReference eventDocumentReference =
        babyCollection.doc(babyId).collection("events").doc(eventId);
    eventDocumentReference.update({
      "babyId": eventData["babyId"],
      "task": eventData["task"],
      "type": eventData["type"],
      "description": eventData["description"],
      "babyExcreta": eventData["babyExcreta"],
      "calories": eventData["calories"],
      "duration": eventData["duration"],
      "startTime": eventData["startTime"],
      "endTime": eventData["endTime"],
      "completed": eventData["completed"],
    });
  }

  // delete an event
  Future deleteEvent(String babyId, String eventId) async {
    await babyCollection.doc(babyId).collection("events").doc(eventId).delete();
  }

  // // Invite user to join as caretaker for baby
  // Future inviteUser(String babyId, String babyName, String searchEmail,
  //     String searchUsername) async {
  //   // get the searched user's uid
  //   var document =
  //       await userCollection.where("email", isEqualTo: searchEmail).get();
  //   var data = Map<String, dynamic>.from(document.docs[0].data() as Map);

  //   // document references
  //   DocumentReference userDocumentReference = userCollection.doc(data['uid']);
  //   DocumentReference babyDocumentReference = babyCollection.doc(babyId);

  //   await userDocumentReference.update({
  //     'babies': FieldValue.arrayUnion(["${babyId}_$babyName"])
  //   });
  //   await babyDocumentReference.update({
  //     'caretakers': FieldValue.arrayUnion(["${data['uid']}_$searchUsername"])
  //   });
  // }

  Future inviteUser(String babyId, String babyName, String searchEmail,
      String searchUsername) async {
    // get the searched user's uid
    var document =
        await userCollection.where("email", isEqualTo: searchEmail).get();
    var data = Map<String, dynamic>.from(document.docs[0].data() as Map);

    // document reference
    DocumentReference userDocumentReference = userCollection.doc(data['uid']);

    await userDocumentReference.update({
      'alert': FieldValue.arrayUnion(
          ["received_${data['uid']}_${searchUsername}_${babyId}_$babyName"])
    });
  }

  Future removeAlert(String alertString) async {
    // document references
    DocumentReference userDocumentReference =
        userCollection.doc(FirebaseAuth.instance.currentUser!.uid);

    // document snapshots
    DocumentSnapshot userDocumentSnapshot = await userDocumentReference.get();
    List<dynamic> alerts = await userDocumentSnapshot['alert'];

    if (alerts.contains(alertString)) {
      await userDocumentReference.update({
        'alert': FieldValue.arrayRemove([alertString])
      });
    }
  }

  Future acceptInvite(String babyId, String userId) async {
    // document references
    DocumentReference userDocumentReference = userCollection.doc(userId);
    DocumentReference babyDocumentReference = babyCollection.doc(babyId);

    // document snapshots
    DocumentSnapshot userDocumentSnapshot = await userDocumentReference.get();
    DocumentSnapshot babyDocumentSnapshot = await babyDocumentReference.get();

    await userDocumentReference.update({
      'babies': FieldValue.arrayUnion(
          ["${babyId}_${babyDocumentSnapshot["babyName"]}"])
    });
    await babyDocumentReference.update({
      'caretakers': FieldValue.arrayUnion(
          ["${userId}_${userDocumentSnapshot["userName"]}"])
    });
  }

  // Kick user from list of caretakers
  Future kickUser(String babyId, String babyName, String caretakerId,
      String caretakerUsername) async {
    // document references
    DocumentReference userDocumentReference = userCollection.doc(caretakerId);
    DocumentReference babyDocumentReference = babyCollection.doc(babyId);

    DocumentSnapshot userDocumentSnapshot = await userDocumentReference.get();
    List<dynamic> babies = await userDocumentSnapshot['babies'];

    if (babies.contains("${babyId}_$babyName")) {
      await userDocumentReference.update({
        'babies': FieldValue.arrayRemove(["${babyId}_$babyName"])
      });
      await babyDocumentReference.update({
        'caretakers':
            FieldValue.arrayRemove(["${caretakerId}_$caretakerUsername"])
      });
    }
  }
}
