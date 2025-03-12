import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserData(
  String email,
  String phone,
  String name,
  String nationalID,
) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('phone', phone);
  await prefs.setString('name', name);
  await prefs.setString('nationalID', nationalID);
}

Future<Map<String, String?>> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    "email": prefs.getString('email') ?? '',
    "phone": prefs.getString('phone') ?? '',
    "name": prefs.getString('name') ?? '',
    "nationalID": prefs.getString('nationalID') ?? '',
  };
}

Future<void> changeLanguage(String languageCode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', languageCode);
}

Future<String?> getLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('language');
}
