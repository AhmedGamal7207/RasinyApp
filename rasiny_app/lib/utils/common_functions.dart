import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

void displayMessageToUser(
  BuildContext context,
  String title,
  String message, {
  Color color = Colors.red,
  void Function()? onPressed,
}) {
  onPressed ??= () => Navigator.of(context).pop();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Smooth rounded corners
        ),
        backgroundColor: Colors.black87, // Elegant dark theme
        title: Column(
          children: [
            Icon(
              Icons.error,
              color: color,
              size: 50, // Big eye-catching icon
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70, // Smooth contrast
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                AppLocalizations.of(context)!.gotIt,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showCaptureDialog(
  BuildContext context,
  String title,
  String message, {
  Color color = Colors.red,
  void Function()? onPressed,
}) {
  onPressed ??= () => Navigator.of(context).pop();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Smooth rounded corners
        ),
        backgroundColor: Colors.black87, // Elegant dark theme
        title: Column(
          children: [
            Icon(
              Icons.error,
              color: color,
              size: 50, // Big eye-catching icon
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70, // Smooth contrast
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                AppLocalizations.of(context)!.gotIt,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
