import 'package:flutter/material.dart';

class ViolationsScreen extends StatelessWidget {
  const ViolationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Violations"), centerTitle: true),
      body: Center(child: Text("Violations will appear here.")),
    );
  }
}
