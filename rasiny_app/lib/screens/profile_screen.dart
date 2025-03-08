import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String?> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userData = {
          "email": prefs.getString('email') ?? "Not Available",
          "phone": prefs.getString('phone') ?? "Not Available",
          "name": prefs.getString('name') ?? "Not Available",
          "nationalID": prefs.getString('nationalID') ?? "Not Available",
        };
        isLoading = false;
      });
    } catch (e) {
      print("Error loading user data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.grey, Colors.blueGrey],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildProfileItem("Name", userData["name"]!),
                    _buildProfileItem("Phone", userData["phone"]!),
                    _buildProfileItem("National ID", userData["nationalID"]!),
                    SizedBox(height: 30),
                  ],
                ),
              ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(color: Colors.blueGrey, fontSize: 16),
          ),
          subtitle: Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Icon(Icons.info_outline, color: Colors.grey),
        ),
      ),
    );
  }
}
