import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rasiny_app/screens/home_screen.dart';
import 'package:rasiny_app/utils/common_functions.dart';
import 'package:rasiny_app/utils/constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    /*void login() async {
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${phoneController.text.trim()}@rasiny.com",
          password: passwordController.text,
        );
        if (context.mounted) {
          Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == "invalid-credential") {
          displayMessageToUser(
            context,
            "Wrong Data",
            "You have entered wrong phone number or password.",
          );
        } else {
          displayMessageToUser(
            context,
            "Network Error",
            "Please check your network connection and try again.",
          );
        }
      }
    }*/

    void login() async {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevents dismissing by tapping outside
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${phoneController.text.trim()}@rasiny.com",
          password: passwordController.text,
        );

        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop(); // Close dialog
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pop(); // Ensure dialog is closed before error message
        }

        String title = "Error";
        String message = "An unexpected error occurred.";

        if (e.code == "invalid-credential") {
          title = "Wrong Data";
          message = "You have entered the wrong phone number or password.";
        } else {
          title = "Network Error";
          message = "Please check your network connection and try again.";
        }

        if (context.mounted) {
          displayMessageToUser(context, title, message);
        }
      }
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/sign_in_bg.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                color: Colors.black.withOpacity(
                  0.7,
                ), // Adjust the opacity (0.0 - 1.0)
                width: double.infinity,
                height: double.infinity,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sign in', style: Constants.kLoginTitleStyle),
                  SizedBox(height: 40),
                  CustomTextField(
                    hintText: 'Phone Number...',
                    controller: phoneController,
                    textInputType: TextInputType.phone,
                  ),
                  CustomTextField(
                    hintText: 'Password...',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Your Password...?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Sign in',
                    onPressed: () {
                      if (phoneController.text.isEmpty) {
                        displayMessageToUser(
                          context,
                          "Phone Number Error",
                          "Please fill in the Phone Number; You can't leave it empty.",
                        );
                        return;
                      }
                      if (passwordController.text.isEmpty) {
                        displayMessageToUser(
                          context,
                          "Password Error",
                          "Please enter a password; it cannot be empty.",
                        );
                        return;
                      }
                      login();
                    },
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/sign_up'),
                    child: const Text.rich(
                      TextSpan(
                        text: "Don't Have Account? ",
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: "SIGN UP",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
