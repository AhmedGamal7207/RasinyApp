import 'package:flutter/material.dart';
import 'package:rasiny_app/screens/home_screen.dart';
import 'package:rasiny_app/screens/profile_screen.dart';
import 'package:rasiny_app/screens/violations_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/otp_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/sign_in': (context) => SignInScreen(),
  '/sign_up': (context) => SignUpScreen(),
  '/otp': (context) => OtpScreen(),
  '/home': (context) => HomeScreen(),
  '/profile': (context) => ProfileScreen(),
  '/violations': (context) => ViolationsScreen(),
};
