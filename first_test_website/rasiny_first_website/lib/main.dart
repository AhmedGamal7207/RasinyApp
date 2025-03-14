import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rasiny_first_website/firebase_options.dart';
import 'package:rasiny_first_website/services/firestore_service.dart';
import 'dart:html' as html;

class ViolationsDashboard extends StatefulWidget {
  const ViolationsDashboard({super.key});

  @override
  ViolationsDashboardState createState() => ViolationsDashboardState();
}

class ViolationsDashboardState extends State<ViolationsDashboard> {
  List<Map<String, dynamic>> _violations = [];
  List<Map<String, dynamic>> _filteredViolations = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Under Review',
    'Approved',
    'Rejected',
  ];

  @override
  void initState() {
    super.initState();
    _loadViolations();
  }

  Future<void> _loadViolations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final violations = await fetchViolations();
      setState(() {
        _violations = violations;
        _applyFilter(_selectedFilter);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackbar('Failed to load violations: $e');
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == 'All') {
        _filteredViolations = List.from(_violations);
      } else {
        _filteredViolations =
            _violations
                .where(
                  (violation) => violation['violation']['status'] == filter,
                )
                .toList();
      }
    });
  }

  Future<void> _updateViolationStatus(
    Map<String, dynamic> violationDict,
    String newStatus,
  ) async {
    try {
      // Here you would update the status in Firestore
      // await _firestoreService.updateViolationStatus(violation['id'], newStatus);

      // For now, we'll just update it locally for demonstration
      setState(() {
        final index = _violations.indexOf(violationDict);
        if (index != -1) {
          // Here we should change the status on Firebase and move the violation to new collection
          // Create a copy of the original dictionary
          Map<String, dynamic> updatedViolation = Map<String, dynamic>.from(
            violationDict["violation"],
          );
          // Update the status field
          String currentStatus = updatedViolation['status'];
          updatedViolation['status'] = newStatus;
          // Assign the updated dictionary to the array
          _violations[index]["violation"] = updatedViolation;
          updateViolationStatFirebase(
            updatedViolation["violation"],
            '${updatedViolation['letters'] ?? '-'} ${updatedViolation['numbers'] ?? '-'}',
            violationDict["id"],
            currentStatus,
            newStatus,
          );
          _loadViolations();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to $newStatus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorSnackbar('Failed to update status: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return DateFormat('MMM dd, yyyy - HH:mm').format(dateTime);
  }

  // Helper function to launch Google Maps
  void launchMapsUrl(double lat, double lng) async {
    String mapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    html.window.open(mapsUrl, "_blank");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Parking Violations Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.white,
            onPressed: _loadViolations,
            tooltip: 'Reload Data',
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredViolations.isEmpty
                    ? Center(
                      child: Text(
                        'No violations found for filter: $_selectedFilter',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: _loadViolations,
                      child: _buildViolationsList(),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Row(
        children: [
          Text(
            'Filter by status: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    _filterOptions
                        .map(
                          (filter) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(filter),
                              selected: _selectedFilter == filter,
                              onSelected: (selected) {
                                if (selected) {
                                  _applyFilter(filter);
                                }
                              },
                              selectedColor: Colors.blue[200],
                              backgroundColor: Colors.white,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${_filteredViolations.length} violations',
            style: TextStyle(color: Colors.blue[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildViolationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredViolations.length,
      itemBuilder: (context, index) {
        final violation = _filteredViolations[index];
        return _buildViolationCard(violation);
      },
    );
  }

  Widget _buildViolationCard(Map<String, dynamic> violationDict) {
    String id = violationDict["id"];
    Map<String, dynamic> violation = violationDict["violation"];
    final statusColor =
        {
          'Under Review': Colors.orange,
          'Approved': Colors.green,
          'Rejected': Colors.red,
        }[violation['status']] ??
        Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Violation ID: $id',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    violation['status'] ?? 'Unknown',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Information

                // Reporter Information
                _buildInfoSection('Reporter Information', [
                  'Phone: ${violation['announcerPhone'] ?? '-'}',
                  'National ID: ${violation['announcerNationalID'] ?? '-'}',
                ]),

                const Divider(),

                _buildInfoSection(
                  'Date and Location',
                  [
                    'Date: ${violation['createdAt'] != null ? _formatTimestamp(violation['createdAt']) : '-'}',
                    // Replace this line:
                    // 'Location: Lat ${violation['latitude'] ?? '-'}, Lng ${violation['longitude'] ?? '-'}',
                  ],
                  // Add this as an additional widget:
                  additionalWidget: Row(
                    children: [
                      Text("Location: "),
                      InkWell(
                        onTap: () {
                          launchMapsUrl(
                            violation['latitude'],
                            violation['longitude'],
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.map, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(
                                'Open Location in Google Maps',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (violation['comment'] != null &&
                    violation['comment'].toString().isNotEmpty) ...[
                  const Divider(),
                  _buildInfoSection('Comment', [violation['comment']]),
                ],

                const Divider(),
                _buildInfoSection('Vehicle Information', [
                  'License Plate: ${violation['letters'] ?? '-'} ${violation['numbers'] ?? '-'}',
                  'Violation Type: ${violation['violation'] ?? '-'}',
                ]),

                const Divider(),
                // Images
                Text(
                  'Images',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      if (violation['imageUrl'] != null)
                        _buildImageContainer(
                          violation['imageUrl'],
                          'Violation Image 1',
                        ),
                      if (violation['imageUrl2'] != null)
                        _buildImageContainer(
                          violation['imageUrl2'],
                          'Violation Image 2',
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Status Update Controls
                Center(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed:
                            () => _updateViolationStatus(
                              violationDict,
                              'Approved',
                            ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.pending_actions,
                          color: Colors.white,
                        ),
                        label: const Text('Under Review'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed:
                            () => _updateViolationStatus(
                              violationDict,
                              'Under Review',
                            ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        ),
                        label: const Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed:
                            () => _updateViolationStatus(
                              violationDict,
                              'Rejected',
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    List<String> details, {
    Widget? additionalWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        ...details.map(
          (detail) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(detail),
          ),
        ),
        if (additionalWidget != null) additionalWidget,
      ],
    );
  }

  Widget _buildImageContainer(String imageUrl, String label) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

// Example of how to use this widget in your main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Violations Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const ViolationsDashboard(),
    );
  }
}
