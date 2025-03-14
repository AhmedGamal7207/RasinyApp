import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasiny_app/utils/constants.dart';

class FirestoreService {
  static CollectionReference users = FirebaseFirestore.instance.collection(
    "users",
  );

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
      'wallet': 0,
      'number_of_announcements_made': 0,
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
    String imageUrl2,
    String comment,
  ) {
    String fullPlate = "$letters $numbers";
    String violationCollectionPath =
        Constants.inverseFeaturesTitles[violation]!;
    CollectionReference violations = FirebaseFirestore.instance.collection(
      violationCollectionPath,
    );
    addAnnouncementPlate(fullPlate, violation);
    return violations.doc(fullPlate).collection("under_review").add({
      'letters': letters,
      'numbers': numbers,
      'latitude': latitude,
      'longitude': longitude,
      'violation': Constants.violationStatements[violation],
      'status': "Under Review",
      'announcerPhone': announcerPhone,
      'announcerNationalID': announcerNationalID,
      'imageUrl': imageUrl,
      'imageUrl2': imageUrl2,
      'comment': comment,
      'createdAt': Timestamp.now(),
    });
  }

  static Future<void> addAnnouncementPlate(String fullPlate, String violation) {
    String violationCollectionPath =
        Constants.inverseFeaturesTitles[violation]!;
    CollectionReference violationsPlates = FirebaseFirestore.instance
        .collection("${violationCollectionPath}_plates");

    return violationsPlates.doc(fullPlate).set({"fullPlate": fullPlate});
  }

  static Future<void> increaseUserWallet(String email, int amount) async {
    DocumentReference userRef = users.doc(email);

    try {
      // Get the current wallet value
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        int currentWalletValue = (userSnapshot['wallet'] ?? 0) as int;

        // Update the wallet value
        await userRef.update({
          'wallet': currentWalletValue + amount,
          'last_wallet_timestamp': Timestamp.now(),
        });
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error updating wallet: $e");
    }
  }

  static Future<void> increaseUserNumberOfAnnouncements(String email) async {
    DocumentReference userRef = users.doc(email);
    int amount = 1;
    try {
      // Get the current wallet value
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        int currentNumberValue =
            (userSnapshot['number_of_announcements_made'] ?? 0) as int;

        // Update the wallet value
        await userRef.update({
          'number_of_announcements_made': currentNumberValue + amount,
          'last_annoucement_timestamp': Timestamp.now(),
        });
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error updating number of announcements made: $e");
    }
  }
}
