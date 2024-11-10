import 'package:flutter/material.dart';
import 'toggle_option.dart';

class SleepTimeToggle extends StatelessWidget {
  final VoidCallback onToggle;
  final TimeOfDay? sleepTime; // Time to display

  const SleepTimeToggle({Key? key, required this.onToggle, this.sleepTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleOption(
      title: 'Sleep Time',
      isSleepTime: true,
      onToggle: onToggle,
      displayTime: sleepTime, // Pass the time to display
    );
  }
}
