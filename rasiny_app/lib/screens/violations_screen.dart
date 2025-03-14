import 'package:flutter/material.dart';
import 'package:rasiny_app/utils/common_functions.dart';
import 'show_violations_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ViolationsScreen extends StatefulWidget {
  @override
  _ViolationsScreenState createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen> {
  final List<TextEditingController> _letterControllers = List.generate(
    3,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> _numberControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _letterFocusNodes = List.generate(
    3,
    (index) => FocusNode(),
  );
  final List<FocusNode> _numberFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  Widget _buildTextField(
    TextEditingController controller,
    FocusNode focusNode,
    FocusNode? nextFocusNode,
    int maxLength,
    String hint,
    bool isLetter,
  ) {
    return Container(
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: maxLength,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isLetter ? Colors.blue : Colors.red,
        ),
        keyboardType: isLetter ? TextInputType.text : TextInputType.number,
        textCapitalization:
            isLetter ? TextCapitalization.characters : TextCapitalization.none,
        decoration: InputDecoration(
          counterText: "",
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),

        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }

  Widget _buildLicensePlateInput() {
    return Localizations.override(
      context: context,
      locale: Locale('en'),
      child: Column(
        children: [
          // Arabic Letters - Right to Left
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return _buildTextField(
                _letterControllers[2 -
                    index], // Reverse order for Arabic letters
                _letterFocusNodes[2 - index],
                index > 0
                    ? _letterFocusNodes[2 - index + 1]
                    : _numberFocusNodes[0],
                1,
                "أ",
                true,
              );
            }),
          ),
          const SizedBox(height: 10),
          // English Numbers - Left to Right
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return _buildTextField(
                _numberControllers[index],
                _numberFocusNodes[index],
                index < 3 ? _numberFocusNodes[index + 1] : null,
                1,
                "0",
                false,
              );
            }),
          ),
        ],
      ),
    );
  }

  void _searchViolations() {
    String letters = _letterControllers.map((c) => c.text).join();
    String numbers = _numberControllers.map((c) => c.text).join();

    if (letters.isEmpty || numbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid plate number")),
      );
      return;
    }

    // Validate letters: Only Arabic letters allowed (No English letters, numbers, symbols, or spaces)
    if (!RegExp(r'^[\u0600-\u06FF]+$').hasMatch(letters)) {
      displayMessageToUser(
        context,
        AppLocalizations.of(context)!.plate_number_error_title,
        AppLocalizations.of(context)!.plate_number_letters_error,
      );
      return;
    }

    // Validate numbers: Only English digits allowed (No letters, symbols, spaces, or Arabic digits)
    if (!RegExp(r'^\d+$').hasMatch(numbers)) {
      displayMessageToUser(
        context,
        AppLocalizations.of(context)!.plate_number_error_title,
        AppLocalizations.of(context)!.plate_number_numbers_error,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ShowViolationsScreen(plateNumber: "$letters $numbers"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.check_violations),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.enter_plate_check_violations,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildLicensePlateInput(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _searchViolations,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.search),
            ),
          ],
        ),
      ),
    );
  }
}
