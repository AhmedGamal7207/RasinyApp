import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
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
                color: Colors.black
                    .withOpacity(0.5), // Adjust the opacity (0.0 - 1.0)
                width: double.infinity,
                height: double.infinity,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sign up',
                    style: TextStyle(fontSize: 28, color: Colors.white)),
                CustomTextField(
                  hintText: 'National ID...',
                  controller: idController,
                  textInputType: TextInputType.number,
                ),
                CustomTextField(
                    hintText: 'User Name...', controller: usernameController),
                CustomTextField(
                    hintText: 'Password...',
                    controller: passwordController,
                    obscureText: true),
                CustomTextField(
                    hintText: 'Confirm Password...',
                    controller: confirmPasswordController,
                    obscureText: true),
                const SizedBox(height: 20),
                CustomButton(
                    text: 'Create Account',
                    onPressed: () {
                      Navigator.pushNamed(context, '/otp');
                    }),
                const SizedBox(height: 20),
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
        ],
      ),
    );
  }
}
