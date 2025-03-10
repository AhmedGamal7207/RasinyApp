import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rasiny_app/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rasiny_app/services/cloudinary_service.dart';
import 'package:rasiny_app/services/firestore_service.dart';
import 'package:rasiny_app/utils/common_functions.dart';
import 'package:rasiny_app/utils/constants.dart';

class PlateNumberScreen extends StatefulWidget {
  final File imageFile;
  final String title;

  const PlateNumberScreen({
    super.key,
    required this.imageFile,
    required this.title,
  });

  @override
  _PlateNumberScreenState createState() => _PlateNumberScreenState();
}

class _PlateNumberScreenState extends State<PlateNumberScreen> {
  bool _isLoading = false;
  final TextEditingController _commentController = TextEditingController();
  final List<TextEditingController> _letterControllers = List.generate(
    3,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> _numberControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _letterFocusNodes = List.generate(
    3,
    (index) => FocusNode(),
  );
  final List<FocusNode> _numberFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  Future<List<double>?> getCurrentLocation() async {
    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double latitude = position.latitude;
    double longitude = position.longitude;
    return [latitude, longitude];
  }

  void _submitPlateNumber() async {
    final letters = _letterControllers.map((c) => c.text).join();
    final numbers = _numberControllers.map((c) => c.text).join();

    if (letters.isEmpty || numbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter at least one letter and one number."),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    List<double>? location = await getCurrentLocation();
    if (location != null) {
      double latitude = location[0];
      double longitude = location[1];
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        try {
          DocumentSnapshot<Map<String, dynamic>> userDoc =
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUser.email)
                  .get();

          if (userDoc.exists) {
            String phone = userDoc.data()?['phone'] ?? "No phone available";
            String nationalID =
                userDoc.data()?['nationalID'] ?? "No ID available";
            String? imageUrl = await uploadImageToCloudinary(
              widget.imageFile,
              Constants.inverseFeaturesTitles[widget.title]!,
            );
            if (imageUrl != null) {
              print("Image uploaded successfully: $imageUrl");
              await FirestoreService.addAnnouncement(
                letters,
                numbers,
                widget.title,
                latitude,
                longitude,
                phone,
                nationalID,
                imageUrl,
                _commentController.text,
              );
            } else {
              displayMessageToUser(
                context,
                "Image Upload Error.",
                "Image couldn't be uploaded. It may be a network error.",
              );
              setState(() {
                _isLoading = false;
              });
              return;
            }
          } else {
            displayMessageToUser(
              context,
              "User data not found.",
              "Please complete your profile to proceed.",
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
        } catch (e) {
          displayMessageToUser(
            context,
            "Error fetching user data.",
            "Something went wrong. Please try again.",
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      } else {
        displayMessageToUser(
          context,
          "User not authenticated.",
          "Please log in to continue.",
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } else {
      displayMessageToUser(
        context,
        "Couldn't complete your request.",
        "Please allow location access to proceed.",
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });
    displayMessageToUser(
      context,
      "Announcement Sent",
      "Your proclamation is under review. Thank you for helping us keeping the streets safe.",
      color: Colors.green,
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    FocusNode focusNode,
    FocusNode? nextFocusNode,
    int maxLength,
    String hint,
    bool isLetter,
  ) {
    return Container(
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: maxLength,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isLetter ? Colors.blue : Colors.red,
        ),
        keyboardType: isLetter ? TextInputType.text : TextInputType.number,
        textCapitalization:
            isLetter ? TextCapitalization.characters : TextCapitalization.none,
        decoration: InputDecoration(
          counterText: "",
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),

        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }

  Widget _buildLicensePlateInput() {
    return Column(
      children: [
        // Arabic Letters - Right to Left
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return _buildTextField(
              _letterControllers[2 - index], // Reverse order for Arabic letters
              _letterFocusNodes[2 - index],
              index > 0
                  ? _letterFocusNodes[2 - index + 1]
                  : _numberFocusNodes[0],
              1,
              "أ",
              true,
            );
          }),
        ),
        const SizedBox(height: 10),
        // English Numbers - Left to Right
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return _buildTextField(
              _numberControllers[index],
              _numberFocusNodes[index],
              index < 3 ? _numberFocusNodes[index + 1] : null,
              1,
              "0",
              false,
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  widget.imageFile,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Please enter the license plate number:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildLicensePlateInput(),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 3,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Add a comment...",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.comment, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitPlateNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Confirm"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
