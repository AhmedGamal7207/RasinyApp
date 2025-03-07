import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            DrawerHeader(
              child: Icon(Icons.car_rental, color: Colors.grey[600]),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.grey[600]),
              title: Text("H O M E"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.grey[600]),
              title: Text("P R O F I L E"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/profile");
              },
            ),
            ListTile(
              leading: Icon(Icons.rule_sharp, color: Colors.grey[600]),
              title: Text("V I O L A T I O N S"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/violations");
              },
            ),
            Expanded(child: Container()),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey[600]),
              title: Text("L O G O U T"),
              onTap: () {
                logout();
                Navigator.pushReplacementNamed(context, "/sign_in");
              },
            ),
          ],
        ),
      ),
    );
  }
}
