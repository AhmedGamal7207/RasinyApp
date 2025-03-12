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

  static const featuresTitles = {
    "parking": "Wrong Parking",
    "tint": "Tinted Windows",
    "stickers": "Stickers",
    "wrong_way": "Wrong-Way Driving",
    "modified": "Modified Cars",
  };
  static const inverseFeaturesTitles = {
    "Wrong Parking": "parking",
    "Tinted Windows": "tint",
    "Stickers": "stickers",
    "Wrong-Way Driving": "wrong_way",
    "Modified Cars": "modified",
    "ركن خاطئ": "parking",
    "زجاج معتم": "tint",
    "ملصقات": "stickers",
    "السير في الاتجاه الخاطئ": "wrong_way",
    "سيارات معدلة": "modified",
  };

  static const violationStatements = {
    "Wrong Parking": "Wrong Parking",
    "Tinted Windows": "Tinted Windows",
    "Stickers": "Stickers",
    "Wrong-Way Driving": "Wrong-Way Driving",
    "Modified Cars": "Modified Cars",
    "ركن خاطئ": "Wrong Parking",
    "زجاج معتم": "Tinted Windows",
    "ملصقات": "Stickers",
    "السير في الاتجاه الخاطئ": "Wrong-Way Driving",
    "سيارات معدلة": "Modified Cars",
  };
  static const violationEnglish2Arabic = {
    "Wrong Parking": "ركن خاطئ",
    "Tinted Windows": "زجاج معتم",
    "Stickers": "ملصقات",
    "Wrong-Way Driving": "السير في الاتجاه الخاطئ",
    "Modified Cars": "سيارات معدلة",
  };

  static const statusEnglish2Arabic = {
    "Under Review": "قيد المراجعة",
    "Approved": "تم التأكيد",
    "Rejected": "تم إزالة المخالفة",
  };

  static const possibleStatuses = ["under_review", "approved", "rejected"];
}
