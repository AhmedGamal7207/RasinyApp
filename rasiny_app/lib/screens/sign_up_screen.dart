import 'package:flutter/material.dart';
import 'package:rasiny_app/screens/otp_screen.dart';
import 'package:rasiny_app/services/phone_auth_service.dart';
import 'package:rasiny_app/utils/common_functions.dart';
import 'package:rasiny_app/utils/constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PhoneAuthService phoneAuthService = PhoneAuthService();

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController idController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    nameController.text = "Ahmed Gamal";
    idController.text = "30312190300176";
    phoneController.text = "01145531800";
    passwordController.text = "123456";
    confirmPasswordController.text = "123456";
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/sign_out_bg.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                color: Colors.black.withOpacity(
                  0.5,
                ), // Adjust the opacity (0.0 - 1.0)
                width: double.infinity,
                height: double.infinity,
              ),
            ],
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sign up', style: Constants.kLoginTitleStyle),
                      SizedBox(height: 60),
                      CustomTextField(
                        hintText: 'Name...',
                        controller: nameController,
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                        hintText: 'National ID...',
                        controller: idController,
                        textInputType: TextInputType.number,
                      ),
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
                      CustomTextField(
                        hintText: 'Confirm Password...',
                        controller: confirmPasswordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Create Account',
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            displayMessageToUser(
                              context,
                              "Name Error",
                              "Please fill in the Name; You can't leave it empty.",
                            );
                            return;
                          }
                          if (idController.text.isEmpty) {
                            displayMessageToUser(
                              context,
                              "National ID Error",
                              "Please fill in the National ID; You can't leave it empty.",
                            );
                            return;
                          }
                          if (idController.text.length != 14) {
                            displayMessageToUser(
                              context,
                              "National ID Error",
                              "The National ID should be 14 digits length, Double check it please.",
                            );
                            return;
                          }
                          if (phoneController.text.isEmpty) {
                            displayMessageToUser(
                              context,
                              "Phone Number Error",
                              "Please fill in the Phone Number; You can't leave it empty.",
                            );
                            return;
                          }
                          if (phoneController.text.length < 10) {
                            displayMessageToUser(
                              context,
                              "Phone Number Error",
                              "The Phone Number seems too short. Please enter a valid number.",
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
                          if (passwordController.text.length < 6) {
                            displayMessageToUser(
                              context,
                              "Password Error",
                              "Password must be at least 6 characters long.",
                            );
                            return;
                          }
                          if (confirmPasswordController.text.isEmpty) {
                            displayMessageToUser(
                              context,
                              "Password Confirmation Error",
                              "Please confirm your password.",
                            );
                            return;
                          }
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            displayMessageToUser(
                              context,
                              "Password Mismatch",
                              "The passwords you entered do not match. Please try again.",
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return OtpScreen(
                                  name: nameController.text,
                                  nationalID: idController.text,
                                  phone: phoneController.text.trim(),
                                  email:
                                      "${phoneController.text.trim()}@rasiny.com",
                                  password: passwordController.text,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 50),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/'),
                        child: const Text.rich(
                          TextSpan(
                            text: "Already Have Account? ",
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: "SIGN IN",
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
            ),
          ),
        ],
      ),
    );
  }
}
