import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rasiny_app/screens/plate_number_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CaptureCarScreen extends StatefulWidget {
  final String title;

  const CaptureCarScreen({super.key, required this.title});

  @override
  _CaptureCarScreenState createState() => _CaptureCarScreenState();
}

class _CaptureCarScreenState extends State<CaptureCarScreen> {
  File? _capturedImage;
  final ImagePicker _picker = ImagePicker();

  // Function to open camera and take photo
  Future<void> _capturePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      File imageFile = File(photo.path);
      setState(() {
        _capturedImage = imageFile;
      });
      _navigateToPlateNumberScreen(imageFile);
    }
  }

  // Navigate to PlateNumberScreen
  void _navigateToPlateNumberScreen(File imageFile) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                PlateNumberScreen(imageFile: imageFile, title: widget.title),
      ),
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
            _capturedImage != null
                ? Image.file(_capturedImage!, height: 200)
                : const Icon(Icons.camera_alt, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _capturePhoto,
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
