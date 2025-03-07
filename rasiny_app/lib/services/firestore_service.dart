import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<void> addUser(
    String name,
    String nationalID,
    String email,
    String phone,
  ) {
    return users.doc(email).set({
      'name': name,
      'nationalID': nationalID,
      'email': email,
      'phone': phone,
      'createdAt': Timestamp.now(),
    });
  }
}
