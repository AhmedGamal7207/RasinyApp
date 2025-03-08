import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> uploadImageToCloudinary(File imageFile, String folder) async {
  final String cloudName =
      "dnkppw2nm"; // Replace with your Cloudinary cloud name
  final String uploadPreset =
      "raseny_presit"; // Replace with your upload preset

  final Uri url = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );

  var request =
      http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] =
            folder // Store inside a specific folder
        ..files.add(await http.MultipartFile.fromPath("file", imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(responseData);
    return jsonData["secure_url"]; // Return the uploaded image URL
  } else {
    print("Failed to upload image: ${response.reasonPhrase}");
    return null;
  }
}
