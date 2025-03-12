import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
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
    final local = AppLocalizations.of(context)!;

    if (otpCode.length < 6) {
      displayMessageToUser(
        context,
        local.verification_code_error_title,
        local.verification_code_error_message,
      );
      return;
    }
    if (otpCode == "000000") {
      register(context);
    } else {
      displayMessageToUser(
        context,
        local.wrong_verification_code_title,
        local.wrong_verification_code_message,
      );
      return;
    }
  }

  void register(BuildContext context) async {
    final local = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      FirestoreService users = FirestoreService();
      await users.addUser(name!, nationalID!, email!, phone!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(local.account_created_success)));
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const SignInScreen();
          },
        ),
      );
    } on FirebaseAuthException {
      Navigator.pop(context);
      displayMessageToUser(
        context,
        local.network_error_title,
        local.network_error_message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

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
                color: Colors.black.withOpacity(0.5),
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
                Text(local.otp_title, style: Constants.kLoginTitleStyle),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      local.otp_message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "smallTextFont",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      color: const Color.fromARGB(217, 219, 196, 181),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.phone_forwarded_outlined,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            phone!,
                            style: const TextStyle(
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
                Text(
                  local.otp_sms_notice,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "smallTextFont",
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: local.verify,
                  onPressed: () {
                    verify_method(otpControllers, context);
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/'),
                  child: Text.rich(
                    TextSpan(
                      text: local.already_have_account,
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: local.sign_in,
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
        color: const Color.fromARGB(217, 219, 196, 181),
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
      ),
    );
  }
}
