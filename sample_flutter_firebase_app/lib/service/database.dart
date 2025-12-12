import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addEventDetails(Map<String, dynamic> eventInfoMap, String id) async {
    // Access Firestore instance and set data to the specified document
    return await FirebaseFirestore.instance
        .collection("Sample") // Access "Event" collection
        .doc(id) // Reference a document with the provided ID
        .set(eventInfoMap); // Set data to the document
  }

  Stream<QuerySnapshot> getEventDetails() {
    return FirebaseFirestore.instance.collection("Sample").snapshots();
  }
}
