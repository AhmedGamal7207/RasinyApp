import 'package:flutter/material.dart';

class Constants {
  static const Color kPrimaryColor = Colors.white;
  static const Color kTextColor = Colors.black;
  static const double kPadding = 16.0;

  static const TextStyle kTitleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
  );

  static const TextStyle kSubtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: kPrimaryColor,
  );

  static const TextStyle kLoginTitleStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: 'loginTitleFont',
  );
}
