import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasiny_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ShowViolationsScreen extends StatefulWidget {
  final String plateNumber;

  const ShowViolationsScreen({Key? key, required this.plateNumber})
    : super(key: key);

  @override
  _ShowViolationsScreenState createState() => _ShowViolationsScreenState();
}

class _ShowViolationsScreenState extends State<ShowViolationsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> violations = [];

  @override
  void initState() {
    super.initState();
    _fetchViolations();
  }

  Future<void> _fetchViolations() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final featuresTitles = [
        "parking",
        "tint",
        "stickers",
        "wrong_way",
        "modified",
      ];

      for (String collection in featuresTitles) {
        final plateRef = firestore
            .collection(collection)
            .doc(widget.plateNumber);
        for (String status in Constants.possibleStatuses) {
          final subcollections = await plateRef.collection(status).get();
          if (subcollections.docs.isNotEmpty) {
            violations.add(subcollections.docs.first.data());
          }
        }
      }
    } catch (e) {}

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildViolationCard(Map<String, dynamic> data) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                data['imageUrl'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${Localizations.localeOf(context).languageCode == 'en' ? data['violation'] : Constants.violationEnglish2Arabic[data['violation']]}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (data['comment'] != null && data['comment'].isNotEmpty)
              Text(
                "${AppLocalizations.of(context)!.user_comment}: ${data['comment']}",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),

            Text(
              "${AppLocalizations.of(context)!.status}: ${Localizations.localeOf(context).languageCode == 'en' ? data['status'] : Constants.statusEnglish2Arabic[data['status']]}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              "${AppLocalizations.of(context)!.date}: ${DateFormat.yMMMd().format(data['createdAt'].toDate())}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String mapsUrl =
                    "https://www.google.com/maps/search/?api=1&query=${data["latitude"]},${data["longitude"]}";
                launch(mapsUrl);
              },
              child: Text(AppLocalizations.of(context)!.view_location),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context)!.violations} - ${widget.plateNumber}",
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : violations.isEmpty
              ? Center(
                child: Text(
                  AppLocalizations.of(context)!.no_violations,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
              : ListView.builder(
                itemCount: violations.length,
                itemBuilder: (context, index) {
                  return _buildViolationCard(violations[index]);
                },
              ),
    );
  }
}
