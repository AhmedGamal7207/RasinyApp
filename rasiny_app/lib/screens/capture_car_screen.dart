import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rasiny_app/screens/plate_number_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:rasiny_app/utils/common_functions.dart';

class CaptureCarScreen extends StatefulWidget {
  final String title;

  const CaptureCarScreen({super.key, required this.title});

  @override
  _CaptureCarScreenState createState() => _CaptureCarScreenState();
}

class _CaptureCarScreenState extends State<CaptureCarScreen> {
  File? _capturedImage1;
  File? _capturedImage2;
  final ImagePicker _picker = ImagePicker();

  // Function to capture the first photo
  Future<void> _captureFirstPhoto() async {
    displayMessageToUser(
      context,
      AppLocalizations.of(context)!.capture_first_image,
      AppLocalizations.of(context)!.capture_first_image_message,
      onPressed: () async {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
        );
        if (photo != null) {
          File imageFile = File(photo.path);
          setState(() {
            _capturedImage1 = imageFile;
          });

          // After first image is taken, show dialog for the second image
          _captureSecondPhoto();
        }
      },
      color: Colors.blue,
    );
  }

  // Function to capture the second photo
  Future<void> _captureSecondPhoto() async {
    displayMessageToUser(
      context,
      AppLocalizations.of(context)!.capture_second_image,
      AppLocalizations.of(context)!.capture_second_image_message,
      onPressed: () async {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
        );
        if (photo != null) {
          File imageFile = File(photo.path);
          setState(() {
            _capturedImage2 = imageFile;
          });

          // Navigate to the next screen with both images
          _navigateToPlateNumberScreen(_capturedImage1!, _capturedImage2!);
        }
      },
      color: Colors.blue,
    );
  }

  // Navigate to PlateNumberScreen
  void _navigateToPlateNumberScreen(File imageFile, File imageFile2) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (context) => PlateNumberScreen(
              imageFile: imageFile,
              title: widget.title,
              imageFile2: imageFile2,
            ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.capture_instruction,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.camera_alt, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _captureFirstPhoto,
              icon: const Icon(Icons.camera),
              label: Text(AppLocalizations.of(context)!.capture_photo),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
