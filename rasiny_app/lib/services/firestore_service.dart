import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasiny_app/utils/constants.dart';

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

  static Future<void> addAnnouncement(
    String letters,
    String numbers,
    String violation,
    double latitude,
    double longitude,
    String announcerPhone,
    String announcerNationalID,
    String imageUrl,
    String comment,
  ) {
    String full_plate = "$letters $numbers";
    String violationCollectionPath =
        Constants.inverseFeaturesTitles[violation]!;
    CollectionReference violations = FirebaseFirestore.instance.collection(
      violationCollectionPath,
    );

    return violations.doc(full_plate).collection("under_review").add({
      'letters': letters,
      'numbers': numbers,
      'latitude': latitude,
      'longitude': longitude,
      'violation': Constants.violationStatements[violation],
      'status': "Under Review",
      'announcerPhone': announcerPhone,
      'announcerNationalID': announcerNationalID,
      'imageUrl': imageUrl,
      'comment': comment,
      'createdAt': Timestamp.now(),
    });
  }
}
