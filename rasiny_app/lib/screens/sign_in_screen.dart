import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                color: Colors.black
                    .withOpacity(0.5), // Adjust the opacity (0.0 - 1.0)
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
                    const Text('Sign in',
                        style: TextStyle(fontSize: 28, color: Colors.white)),
                    SizedBox(height: 40),
                    CustomTextField(
                      hintText: 'Phone Number...',
                      controller: phoneController,
                      textInputType: TextInputType.phone,
                    ),
                    CustomTextField(
                        hintText: 'Password...',
                        controller: passwordController,
                        obscureText: true),
                    const SizedBox(height: 10),
                    Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Your Password...?',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                    const SizedBox(height: 20),
                    CustomButton(text: 'Sign in', onPressed: () {}),
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
                )),
          ),
        ],
      ),
    );
  }
}
