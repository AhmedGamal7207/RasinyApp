import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rasiny_app/screens/sign_in_screen.dart';
import 'package:rasiny_app/services/firestore_service.dart';
import 'package:rasiny_app/utils/common_functions.dart';
import 'package:rasiny_app/utils/constants.dart';
import '../widgets/custom_button.dart';

class OtpScreen extends StatelessWidget {
  final String? name;
  final String? nationalID;
  final String? phone;
  final String? email;
  final String? password;
  const OtpScreen({
    super.key,
    this.name,
    this.phone,
    this.nationalID,
    this.email,
    this.password,
  });

  void verify_method(
    List<TextEditingController> controllers,
    BuildContext context,
  ) {
    String otpCode = controllers.map((c) => c.text).join();

    if (otpCode.length < 6) {
      displayMessageToUser(
        context,
        "Verfication Code Error",
        "Please fill in the verfication code correctly.",
      );
      return;
    }
    if (otpCode == "000000") {
      register(context);
    } else {
      displayMessageToUser(
        context,
        "Wrong Verfication Code",
        "The verfication code you have entered isn't correct.",
      );
      return;
    }
  }

  void register(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      FirestoreService users = FirestoreService();
      await users.addUser(name!, nationalID!, email!, phone!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Account has been created successully, Sign In Please.",
          ),
        ),
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SignInScreen();
          },
        ),
      );
    } on FirebaseAuthException {
      Navigator.pop(context);
      displayMessageToUser(
        context,
        "Network Error",
        "Please check your network connection and try again.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> otpControllers = List.generate(
      6,
      (index) => TextEditingController(),
    );
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/otp_bg.jpg',
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
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('OTP', style: Constants.kLoginTitleStyle),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity, // Ensure it takes full width
                  child: FittedBox(
                    fit: BoxFit.cover, // Prevents text from overflowing
                    child: Text(
                      'The OTP Message Sent To The Following Number:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "smallTextFont",
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      0.3,
                    ), // Light opacity white box
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      color: const Color.fromARGB(
                        217,
                        219,
                        196,
                        181,
                      ), // Background color
                      padding: const EdgeInsets.all(
                        8,
                      ), // Optional: adds some spacing inside the container
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.phone_forwarded_outlined,
                            color: Colors.black,
                          ), // Icon color
                          const SizedBox(width: 10),
                          Text(
                            phone!,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => _otpBox(
                      context,
                      otpControllers[index],
                      index < 5 ? otpControllers[index + 1] : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'SMS has been sent on your phone to verify the registered mobile number with the app',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "smallTextFont",
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'Verify',
                  onPressed: () {
                    verify_method(otpControllers, context);
                  },
                ),

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

  Widget _otpBox(
    BuildContext context,
    TextEditingController controller,
    TextEditingController? nextController,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          217,
          219,
          196,
          181,
        ), // Color with 72% opacity
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextController != null) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
