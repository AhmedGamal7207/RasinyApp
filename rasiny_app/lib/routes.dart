import 'package:flutter/material.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/otp_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/sign_in': (context) => const SignInScreen(),
  '/sign_up': (context) => const SignUpScreen(),
  '/otp': (context) => const OtpScreen(),
};
