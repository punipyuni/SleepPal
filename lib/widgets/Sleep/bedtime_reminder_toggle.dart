import 'package:flutter/material.dart';
import 'toggle_option.dart';

class BedtimeReminderToggle extends StatelessWidget {
  final VoidCallback onToggle;
  final TimeOfDay? reminderTime; // Time to display

  const BedtimeReminderToggle({Key? key, required this.onToggle, this.reminderTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleOption(
      title: 'Bedtime Reminder',
      onToggle: onToggle,
      displayTime: reminderTime, // Pass the time to display
    );
  }
}
