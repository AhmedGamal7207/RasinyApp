import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthService {
  final FirebaseAuth firebaseAuthObj = FirebaseAuth.instance;

  String? verficationID;

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    BuildContext context,
  ) async {
    await firebaseAuthObj.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-sign in on some devices
        await firebaseAuthObj.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Phone number automatically verified and signed in."),
          ),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification Failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        verficationID = verificationId;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("OTP sent to $phoneNumber")));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verficationID = verificationId;
      },
    );
  }

  Future<void> verifyOTP(String otp, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verficationID!,
        smsCode: otp,
      );
      UserCredential userCredential = await firebaseAuthObj
          .signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Phone number verified successfully!")),
      );

      // Create the account in Firebase after verification
      await _createUser(userCredential.user!);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid OTP: $e")));
    }
  }

  Future<void> _createUser(User user) async {
    // Add user details to Firestore or Realtime Database
    // Example:
    // FirebaseFirestore.instance.collection('users').doc(user.uid).set({'phone': user.phoneNumber});
  }
}
