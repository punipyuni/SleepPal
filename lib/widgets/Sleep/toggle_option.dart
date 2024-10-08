import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleeppal_update/widgets/Sleep/time_range_picker.dart';

class ToggleOption extends StatefulWidget {
  final String title;
  final bool isSleepTime; // Add this to differentiate between bedtime and sleep time

  const ToggleOption({
    Key? key,
    required this.title,
    this.isSleepTime = false, // Default to false
  }) : super(key: key);

  @override
  _ToggleOptionState createState() => _ToggleOptionState();
}

class _ToggleOptionState extends State<ToggleOption> {
  bool isOn = false;
  TimeOfDay bedtime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay startTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 6, minute: 0);

  Future<void> _showCupertinoTimePicker(BuildContext context, bool isBedtime) async {
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
                  initialDateTime: DateTime(2020, 1, 1, isBedtime ? bedtime.hour : startTime.hour, isBedtime ? bedtime.minute : startTime.minute),
                  onDateTimeChanged: (DateTime newDateTime) {
                    if (isBedtime) {
                      setState(() {
                        bedtime = TimeOfDay.fromDateTime(newDateTime);
                      });
                    } else {
                      setState(() {
                        if (isOn) {
                          startTime = TimeOfDay.fromDateTime(newDateTime);
                        } else {
                          endTime = TimeOfDay.fromDateTime(newDateTime);
                        }
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
        if (isBedtime) {
          bedtime = pickedTime;
        } else {
          // Handle start and end time based on your logic
          if (isOn) {
            startTime = pickedTime;
          } else {
            endTime = pickedTime;
          }
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
    return GestureDetector(
      onTap: () async {
        if (isOn) {
          if (widget.isSleepTime) {
            // Show custom time range picker dialog for sleep time
            final result = await showDialog<List<TimeOfDay>>(
              context: context,
              builder: (context) => TimeRangePickerDialog(
                initialStartTime: startTime,
                initialEndTime: endTime,
              ),
            );

            if (result != null && result.length == 2) {
              setState(() {
                startTime = result[0];
                endTime = result[1];
              });
            }
          } else {
            // Show Cupertino time picker for bedtime
            await _showCupertinoTimePicker(context, true);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Color(0xFF272D42),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(color: Colors.white),
                ),
                Switch(
                  value: isOn,
                  onChanged: (value) => setState(() => isOn = value),
                  activeColor: Color(0xFF6A7BFF),
                ),
              ],
            ),
            if (isOn) ...[
              if (widget.isSleepTime) ...[
                Text(
                  'Sleep Start Time: ${_formatTo24Hour(startTime)}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                SizedBox(height: 8), // Space between texts
                Text(
                  'Sleep End Time: ${_formatTo24Hour(endTime)}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ] else ...[
                Text(
                  'Bedtime: ${_formatTo24Hour(bedtime)}', // Displaying bedtime in 24-hour format
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}