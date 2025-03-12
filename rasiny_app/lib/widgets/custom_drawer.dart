import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
              title: Text(AppLocalizations.of(context)!.drawer_home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.grey[600]),
              title: Text(AppLocalizations.of(context)!.drawer_profile),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/profile");
              },
            ),
            ListTile(
              leading: Icon(Icons.rule_sharp, color: Colors.grey[600]),
              title: Text(AppLocalizations.of(context)!.drawer_violations),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/violations");
              },
            ),
            Expanded(child: Container()),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey[600]),
              title: Text(AppLocalizations.of(context)!.drawer_logout),
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
