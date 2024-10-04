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
            // Show time picker for bedtime
            final newBedtime = await showTimePicker(
              context: context,
              initialTime: bedtime,
            );
            if (newBedtime != null) {
              setState(() => bedtime = newBedtime);
            }
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
                  'Sleep Start Time: ${startTime.format(context)}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                SizedBox(height: 8), // Space between texts
                Text(
                  'Sleep End Time: ${endTime.format(context)}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ] else ...[
                Text(
                  '${bedtime.format(context)}', // Displaying bedtime
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