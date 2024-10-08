import 'package:flutter/cupertino.dart';
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

  Future<void> _showCupertinoTimePicker(
      BuildContext context, bool isStart) async {
    final TimeOfDay? pickedTime = await showModalBottomSheet<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true, // Enable 24-hour format
                  initialDateTime: DateTime(
                      2020,
                      1,
                      1,
                      isStart ? startTime.hour : endTime.hour,
                      isStart ? startTime.minute : endTime.minute),
                  onDateTimeChanged: (DateTime newDateTime) {
                    if (isStart) {
                      setState(() {
                        startTime = TimeOfDay.fromDateTime(newDateTime);
                      });
                    } else {
                      setState(() {
                        endTime = TimeOfDay.fromDateTime(newDateTime);
                      });
                    }
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
      });
    }
  }

  String _formatTo24Hour(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
                onPressed: () => _showCupertinoTimePicker(context, true),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  backgroundColor: const Color(0xFF272D42), // Custom color
                ),
                child: Text(
                  'Start Time: ${_formatTo24Hour(startTime)}', // Use custom format function
                  style:
                      const TextStyle(color: Colors.white), // White text color
                ),
              ),
            ),
            const SizedBox(height: 16), // Add space between buttons
            // End Time Button
            SizedBox(
              width: double.infinity, // Make button full width
              child: ElevatedButton(
                onPressed: () => _showCupertinoTimePicker(context, false),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  backgroundColor: const Color(0xFF272D42), // Custom color
                ),
                child: Text(
                  'End Time: ${_formatTo24Hour(endTime)}', // Use custom format function
                  style:
                      const TextStyle(color: Colors.white), // White text color
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
