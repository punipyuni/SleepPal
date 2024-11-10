
import 'package:flutter/material.dart';

class StatsHeader extends StatelessWidget {
  const StatsHeader({Key? key}) : super(key: key);

  @override
 Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0), // Padding for top, left, and right
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Statistics',
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
