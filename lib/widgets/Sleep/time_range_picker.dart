import 'package:flutter/material.dart';

class TimeRangePickerDialog extends StatefulWidget {
  final TimeOfDay initialStartTime;
  final TimeOfDay initialEndTime;

  const TimeRangePickerDialog({
    Key? key,
    required this.initialStartTime,
    required this.initialEndTime,
  }) : super(key: key);

  @override
  _TimeRangePickerDialogState createState() => _TimeRangePickerDialogState();
}

class _TimeRangePickerDialogState extends State<TimeRangePickerDialog> {
  late TimeOfDay startTime;
  late TimeOfDay endTime;

  @override
  void initState() {
    super.initState();
    startTime = widget.initialStartTime;
    endTime = widget.initialEndTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Start and End Time'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Start Time Button
            SizedBox(
              width: double.infinity, // Make button full width
              child: ElevatedButton(
                onPressed: () async {
                  final newStartTime = await showTimePicker(
                    context: context,
                    initialTime: startTime,
                  );
                  if (newStartTime != null) {
                    setState(() => startTime = newStartTime);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xFF272D42), // Custom color
                ),
                child: Text(
                  'Start Time: ${startTime.format(context)}',
                  style: const TextStyle(color: Colors.white), // White text color
                ),
              ),
            ),
            const SizedBox(height: 16), // Add space between buttons
            // End Time Button
            SizedBox(
              width: double.infinity, // Make button full width
              child: ElevatedButton(
                onPressed: () async {
                  final newEndTime = await showTimePicker(
                    context: context,
                    initialTime: endTime,
                  );
                  if (newEndTime != null) {
                    setState(() => endTime = newEndTime);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xFF272D42), // Custom color
                ),
                child: Text(
                  'End Time: ${endTime.format(context)}',
                  style: const TextStyle(color: Colors.white), // White text color
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop([startTime, endTime]);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}