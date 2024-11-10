import 'package:flutter/material.dart';

class SingleTimePickerDialog extends StatelessWidget {
  final TimeOfDay initialTime;

  const SingleTimePickerDialog({
    Key? key,
    required this.initialTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Reminder Time'),
      content: SizedBox(
        height: 200, // Set a fixed height for the dialog
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Show the time picker directly
              final TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: initialTime,
              );

              if (selectedTime != null) {
                Navigator.of(context).pop(selectedTime); // Return the selected time
              } else {
                Navigator.of(context).pop(); // Close dialog if no time was selected
              }
            },
            child: const Text('Pick a Time'),
          ),
        ),
      ),
    );
  }
}