import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rasiny_app/screens/home_screen.dart';
import 'package:rasiny_app/utils/common_functions.dart';
import 'package:rasiny_app/utils/constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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

        String title = AppLocalizations.of(context)!.error;
        String message = AppLocalizations.of(context)!.unexpectedError;

        if (e.code == "invalid-credential") {
          title = AppLocalizations.of(context)!.wrongData;
          message = AppLocalizations.of(context)!.invalidCredentials;
        } else {
          title = AppLocalizations.of(context)!.networkError;
          message = AppLocalizations.of(context)!.checkNetwork;
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
                  Text(
                    AppLocalizations.of(context)!.signIn, // Sign in
                    style: Constants.kLoginTitleStyle,
                  ),
                  SizedBox(height: 40),
                  CustomTextField(
                    hintText: AppLocalizations.of(context)!.phoneNumber,
                    controller: phoneController,
                    textInputType: TextInputType.phone,
                  ),
                  CustomTextField(
                    hintText: AppLocalizations.of(context)!.password,
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
                          AppLocalizations.of(context)!.forgotPassword,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: AppLocalizations.of(context)!.signIn,
                    onPressed: () {
                      if (phoneController.text.isEmpty) {
                        displayMessageToUser(
                          context,
                          AppLocalizations.of(context)!.phoneError,
                          AppLocalizations.of(context)!.emptyPhone,
                        );
                        return;
                      }
                      if (passwordController.text.isEmpty) {
                        displayMessageToUser(
                          context,
                          AppLocalizations.of(context)!.passwordError,
                          AppLocalizations.of(context)!.emptyPassword,
                        );
                        return;
                      }
                      login();
                    },
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/sign_up'),
                    child: Text.rich(
                      TextSpan(
                        text: AppLocalizations.of(context)!.noAccount,
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.signUpCapital,
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
