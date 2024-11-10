import 'package:flutter/material.dart';

class SleepbotHeader extends StatelessWidget {
  const SleepbotHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding( // Wrap with Padding
      padding: const EdgeInsets.all(16.0), // Set padding to 16 pixels on all sides
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'SleepBot',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}