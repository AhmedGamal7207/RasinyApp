import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasiny_first_website/utils/constants.dart';

Future<List<String>> fetchDocumentNames(String collection) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    QuerySnapshot snapshot =
        await firestore.collection('${collection}_plates').get();
    List<String> names = snapshot.docs.map((doc) => doc.id).toList();
    return names;
  } catch (e) {
    print('Error fetching document names: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchViolations() async {
  List<Map<String, dynamic>> violations = [];
  try {
    final firestore = FirebaseFirestore.instance;
    final featuresTitles = [
      "parking",
      "tint",
      "stickers",
      "wrong_way",
      "modified",
    ];

    for (String collection in featuresTitles) {
      List<String> collectionPlates = await fetchDocumentNames(collection);
      for (String plate in collectionPlates) {
        final plateRef = firestore.collection(collection).doc(plate);

        for (String status in Constants.possibleStatuses) {
          final subcollections = await plateRef.collection(status).get();

          for (var doc in subcollections.docs) {
            Map<String, dynamic> violationData = {"violation": {}, "id": ""};
            violationData["violation"] = doc.data();
            violationData["id"] = doc.id;
            violations.add(
              violationData,
            ); // Add all documents' data to the list
          }
        }
      }
    }
    return violations;
  } catch (e) {
    print("Error in fetching violations: $e");
    return [];
  }
}

Future<void> updateViolationStatFirebase(
  String violation,
  String fullPlate,
  String id,
  String currentStatus,
  String newStatus,
) async {
  violation = Constants.inverseFeaturesTitles[violation]!;
  currentStatus = Constants.inverseStatsTitles[currentStatus]!;
  newStatus = Constants.inverseStatsTitles[newStatus]!;
  final sourceData =
      await FirebaseFirestore.instance
          .collection(violation)
          .doc(fullPlate)
          .collection(currentStatus)
          .doc(id)
          .get();
  if (sourceData.exists) {
    Map<String, dynamic> currentData = sourceData.data()!;
    currentData["status"] = Constants.statsTitles[newStatus];

    await FirebaseFirestore.instance
        .collection(violation)
        .doc(fullPlate)
        .collection(newStatus)
        .doc(id)
        .set(currentData);

    await FirebaseFirestore.instance
        .collection(violation)
        .doc(fullPlate)
        .collection(currentStatus)
        .doc(id)
        .delete();
    if (newStatus == "approved") {
      increaseUserWallet('${currentData['announcerPhone']}@rasiny.com', 20);
    }
    if (currentStatus == "approved" && newStatus != "approved") {
      increaseUserWallet('${currentData['announcerPhone']}@rasiny.com', -20);
    }
  }
}

CollectionReference users = FirebaseFirestore.instance.collection("users");

Future<void> increaseUserWallet(String email, int amount) async {
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
