import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rasiny_app/screens/capture_car_screen.dart';
import 'package:rasiny_app/services/shared_preferences.dart';
import 'package:rasiny_app/utils/constants.dart';
import 'package:rasiny_app/widgets/custom_drawer.dart';
import 'package:rasiny_app/widgets/custom_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.email)
          .get();
    }

    return Scaffold(
      appBar: AppBar(title: Text("Home"), centerTitle: true),
      body: FutureBuilder(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            Map<String, dynamic>? userData = snapshot.data!.data();
            if (userData == null) {
              return Center(child: Text("User data not found."));
            }
            String email = userData["email"];
            String phone = userData["phone"];
            String name = userData["name"];
            String nationalID = userData["nationalID"];
            saveUserData(email, phone, name, nationalID);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Hello, ",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "smallTextFont",
                          ),
                        ),
                        Text(
                          "$name ♥",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "smallTextFont",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    FeatureTile(
                      icon: Icons.directions_car,
                      title: Constants.featuresTitles["parking"]!,
                      subtitle:
                          "Illegally parking beside another parked vehicle or in a wrong place.",
                      color: Colors.blueAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CaptureCarScreen(
                                title: Constants.featuresTitles["parking"]!,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    FeatureTile(
                      icon: Icons.visibility_off,
                      title: Constants.featuresTitles["tint"]!,
                      subtitle: "Using overly dark or illegal window tints.",
                      color: Colors.greenAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CaptureCarScreen(
                                title: Constants.featuresTitles["tint"]!,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    FeatureTile(
                      icon: Icons.sticky_note_2_outlined,
                      title: Constants.featuresTitles["stickers"]!,
                      subtitle: "Cars with illegal stickers.",
                      color: Colors.orangeAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CaptureCarScreen(
                                title: Constants.featuresTitles["stickers"]!,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    FeatureTile(
                      icon: Icons.warning,
                      title: Constants.featuresTitles["wrong_way"]!,
                      subtitle: "Driving against the designated traffic flow.",
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(height: 15),
                    FeatureTile(
                      icon: Icons.electric_moped_outlined,
                      title: Constants.featuresTitles["modified"]!,
                      subtitle: "Cars that are illegaly modified.",
                      color: Colors.purpleAccent,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text("Error retrieving your data."));
          }
        },
      ),
      drawer: MyDrawer(),
    );
  }
}
