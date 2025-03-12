import 'package:flutter/material.dart';
import 'package:rasiny_app/services/shared_preferences.dart';
import 'package:rasiny_app/utils/common_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String?> userData = {};
  bool isLoading = true;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadLanguage();
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
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.profile,
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
                    _buildProfileItem(
                      AppLocalizations.of(context)!.name,
                      userData["name"]!,
                    ),
                    _buildProfileItem(
                      AppLocalizations.of(context)!.phone_number,
                      userData["phone"]!,
                    ),
                    _buildProfileItem(
                      AppLocalizations.of(context)!.national_id,
                      userData["nationalID"]!,
                    ),
                    _buildLanguageSelector(),
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

  Widget _buildLanguageSelector() {
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
            AppLocalizations.of(context)!.language,
            style: TextStyle(color: Colors.blueGrey, fontSize: 16),
          ),
          subtitle: DropdownButton<String>(
            value: _selectedLanguage,
            items: [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ar', child: Text('العربية')),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                changeLanguage(newValue);
                if (newValue != _selectedLanguage) {
                  displayMessageToUser(
                    context,
                    AppLocalizations.of(context)!.language_change_title,
                    AppLocalizations.of(context)!.language_change_message,
                    color: Colors.grey,
                  );
                }

                setState(() {
                  _selectedLanguage = newValue;
                });
              }
            },
          ),
          leading: Icon(Icons.language, color: Colors.grey),
        ),
      ),
    );
  }
}
