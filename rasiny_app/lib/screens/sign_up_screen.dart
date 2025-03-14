import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
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
    final localizations = AppLocalizations.of(context)!;

    TextEditingController nameController = TextEditingController();
    TextEditingController idController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

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
                color: Colors.black.withOpacity(0.5),
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
                      Text(
                        localizations.sign_up,
                        style: Constants.kLoginTitleStyle,
                      ),
                      SizedBox(height: 60),
                      CustomTextField(
                        hintText: localizations.name_hint,
                        controller: nameController,
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                        hintText: localizations.id_hint,
                        controller: idController,
                        textInputType: TextInputType.number,
                      ),
                      CustomTextField(
                        hintText: localizations.phone_hint,
                        controller: phoneController,
                        textInputType: TextInputType.phone,
                      ),
                      CustomTextField(
                        hintText: localizations.password_hint,
                        controller: passwordController,
                        obscureText: true,
                      ),
                      CustomTextField(
                        hintText: localizations.confirm_password_hint,
                        controller: confirmPasswordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: localizations.create_account,
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            displayMessageToUser(
                              context,
                              localizations.name_error_title,
                              localizations.name_error_message,
                            );
                            return;
                          }
                          // Check if name contains only letters (no numbers or symbols)
                          if (!RegExp(
                            r'^[a-zA-Z\s]+$',
                          ).hasMatch(nameController.text)) {
                            displayMessageToUser(
                              context,
                              localizations.name_error_title,
                              localizations.name_invalid_message,
                            );
                            return;
                          }
                          if (idController.text.isEmpty) {
                            displayMessageToUser(
                              context,
                              localizations.id_error_title,
                              localizations.id_empty_error,
                            );
                            return;
                          }
                          // Check if ID contains only numbers (no letters, symbols, or spaces)
                          if (!RegExp(r'^\d+$').hasMatch(idController.text)) {
                            displayMessageToUser(
                              context,
                              localizations.id_error_title,
                              localizations.id_invalid_error,
                            );
                            return;
                          }
                          if (idController.text.length != 14) {
                            displayMessageToUser(
                              context,
                              localizations.id_error_title,
                              localizations.id_length_error,
                            );
                            return;
                          }
                          if (phoneController.text.isEmpty) {
                            displayMessageToUser(
                              context,
                              localizations.phone_error_title,
                              localizations.phone_empty_error,
                            );
                            return;
                          }
                          if (phoneController.text.length != 11) {
                            displayMessageToUser(
                              context,
                              localizations.phone_error_title,
                              localizations.phone_length_error,
                            );
                            return;
                          }
                          // Check if phone number contains only numbers (no letters, symbols, or spaces)
                          if (!RegExp(
                            r'^\d+$',
                          ).hasMatch(phoneController.text)) {
                            displayMessageToUser(
                              context,
                              localizations.phone_error_title,
                              localizations.phone_invalid_error,
                            );
                            return;
                          }
                          if (passwordController.text.isEmpty) {
                            displayMessageToUser(
                              context,
                              localizations.password_error_title,
                              localizations.password_empty_error,
                            );
                            return;
                          }
                          if (passwordController.text.length < 6) {
                            displayMessageToUser(
                              context,
                              localizations.password_error_title,
                              localizations.password_length_error,
                            );
                            return;
                          }
                          if (confirmPasswordController.text.isEmpty) {
                            displayMessageToUser(
                              context,
                              localizations.confirm_password_error_title,
                              localizations.confirm_password_error_message,
                            );
                            return;
                          }
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            displayMessageToUser(
                              context,
                              localizations.password_mismatch_title,
                              localizations.password_mismatch_message,
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
                        child: Text.rich(
                          TextSpan(
                            text: localizations.already_have_account,
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: localizations.sign_in,
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
