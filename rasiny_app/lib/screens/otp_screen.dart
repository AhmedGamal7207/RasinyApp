import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> otpControllers =
        List.generate(6, (index) => TextEditingController());
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
                const Text('OTP',
                    style: TextStyle(fontSize: 28, color: Colors.white)),
                const SizedBox(height: 10),
                const Text('The OTP Message Sent To The Following Number:',
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.3), // Light opacity white box
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        color: const Color.fromARGB(
                            217, 219, 196, 181), // Background color
                        padding: const EdgeInsets.all(
                            8), // Optional: adds some spacing inside the container
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.phone_forwarded_outlined,
                                color: Colors.black), // Icon color
                            const SizedBox(width: 10),
                            const Text(
                              'XXXXXXXXXX51',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      6,
                      (index) => _otpBox(context, otpControllers[index],
                          index < 5 ? otpControllers[index + 1] : null)),
                ),
                const SizedBox(height: 20),
                CustomButton(
                    text: 'Verify',
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    }),
                const SizedBox(height: 50),
                const Text(
                  'SMS has been sent on your phone to verify the registered mobile number with the app',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 70),
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

  Widget _otpBox(BuildContext context, TextEditingController controller,
      TextEditingController? nextController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 50,
      decoration: BoxDecoration(
        color:
            const Color.fromARGB(217, 219, 196, 181), // Color with 72% opacity
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
