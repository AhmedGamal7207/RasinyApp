import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:rasiny_app/screens/capture_car_screen.dart';
import 'package:rasiny_app/services/shared_preferences.dart';
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

    AppLocalizations local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home_title),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                AppLocalizations.of(
                  context,
                )!.error_message(snapshot.error.toString()),
              ),
            );
          } else if (snapshot.hasData) {
            Map<String, dynamic>? userData = snapshot.data!.data();
            if (userData == null) {
              return Center(
                child: Text(AppLocalizations.of(context)!.user_data_not_found),
              );
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
                          AppLocalizations.of(context)!.hello,
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
                      title: local.parking,
                      subtitle: AppLocalizations.of(context)!.illegally_parking,
                      color: Colors.blueAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CaptureCarScreen(title: local.parking);
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    FeatureTile(
                      icon: Icons.visibility_off,
                      title: local.tint,
                      subtitle: AppLocalizations.of(context)!.using_dark_tint,
                      color: Colors.greenAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CaptureCarScreen(title: local.tint);
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    FeatureTile(
                      icon: Icons.sticky_note_2_outlined,
                      title: local.stickers,
                      subtitle: AppLocalizations.of(context)!.illegal_stickers,
                      color: Colors.orangeAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CaptureCarScreen(title: local.stickers);
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    FeatureTile(
                      icon: Icons.warning,
                      title: local.stickers,
                      subtitle: AppLocalizations.of(context)!.wrong_way_driving,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(height: 15),
                    FeatureTile(
                      icon: Icons.electric_moped_outlined,
                      title: local.modified,
                      subtitle:
                          AppLocalizations.of(context)!.illegally_modified,
                      color: Colors.purpleAccent,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text(AppLocalizations.of(context)!.error_retrieving_data),
            );
          }
        },
      ),
      drawer: MyDrawer(),
    );
  }
}
