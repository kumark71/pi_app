import 'package:flutter/material.dart';

class ResponsiveVirtualKeyboard extends StatefulWidget {
  final Function(String) onKeyPress;

  ResponsiveVirtualKeyboard({required this.onKeyPress});

  @override
  _ResponsiveVirtualKeyboardState createState() =>
      _ResponsiveVirtualKeyboardState();
}

class _ResponsiveVirtualKeyboardState extends State<ResponsiveVirtualKeyboard> {
  bool isUppercase = false; // Track uppercase/lowercase toggle

  // List of keys organized into 5 lines, without 123 and @ keys
  final List<List<String>> keyRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'Backspace'],
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Shift', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Enter'],
    ['Space', '.'],
  ];

  // Build UI for each key, adjusting for uppercase/lowercase
  Widget _buildKey(String key) {
    bool isSpecialKey = (key == 'Shift' ||
        key == 'Backspace' ||
        key == 'Space' ||
        key == 'Enter');
    // Toggle between uppercase and lowercase characters
    String displayKey =
        isUppercase && !isSpecialKey ? key.toUpperCase() : key.toLowerCase();

    return Expanded(
      flex: key == 'Space' ? 5 : 1, // Make spacebar take up more slots
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () {
            if (key == 'Shift') {
              setState(() {
                isUppercase = !isUppercase; // Toggle uppercase/lowercase
              });
            } else {
              widget.onKeyPress(
                  isSpecialKey ? key : displayKey); // Handle key press
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[800], // Key background color
              borderRadius: BorderRadius.circular(8), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: isSpecialKey
                ? _buildSpecialKeyIcon(key)
                : Text(
                    displayKey,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20, // Responsive font size
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // Display icons for special keys (Shift, Backspace, Enter, Space)
  Widget _buildSpecialKeyIcon(String key) {
    switch (key) {
      case 'Shift':
        return Icon(Icons.arrow_upward, color: Colors.white);
      case 'Backspace':
        return Icon(Icons.backspace, color: Colors.white);
      case 'Enter':
        return Icon(Icons.keyboard_return, color: Colors.white);
      case 'Space':
        return Icon(Icons.space_bar, color: Colors.white);
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54, // Dark background color for keyboard
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keyRows.map((row) {
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((key) {
                return _buildKey(key);
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
