import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../notification.dart'; // Ensure you have your NotificationService class implemented

class TimeRangePickerDialog extends StatefulWidget {
  final TimeOfDay initialStartTime;
  final TimeOfDay initialEndTime;

  const TimeRangePickerDialog({
    Key? key,
    required this.initialStartTime,
    required this.initialEndTime, required bool isNotificationPicker,
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

  Future<void> _showCupertinoTimePicker(BuildContext context, bool isStart) async {
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
                  use24hFormat: true,
                  initialDateTime: DateTime(
                    2020,
                    1,
                    1,
                    isStart ? startTime.hour : endTime.hour,
                    isStart ? startTime.minute : endTime.minute,
                  ),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      if (isStart) {
                        startTime = TimeOfDay.fromDateTime(newDateTime);
                      } else {
                        endTime = TimeOfDay.fromDateTime(newDateTime);
                      }
                    });
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

  Future<void> _scheduleNotification() async {
    final DateTime now = DateTime.now();
    final DateTime bedtimeToday = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );

    // Schedule the notification for today if the time hasn't passed, otherwise for tomorrow
    DateTime scheduledDate = bedtimeToday;
    if (bedtimeToday.isBefore(now)) {
      scheduledDate = bedtimeToday.add(const Duration(days: 1));
    }

    await NotificationService.scheduleNotification(
      "Bedtime Reminder",
      "It's time to sleep!",
      scheduledDate,
    );

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bedtime reminder has been set')),
    );
  }

  String _formatTo24Hour(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Notification Time Range'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCupertinoTimePicker(context, true),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                backgroundColor: const Color(0xFF272D42),
              ),
              child: Text(
                'Notify at ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await _scheduleNotification();
            Navigator.of(context).pop([startTime, endTime]);
          },
          child: const Text('Set Bed time'),
        ),
      ],
    );
  }
}

class BedtimePickerDialog extends StatefulWidget {
  final TimeOfDay initialBedtime;

  const BedtimePickerDialog({
    Key? key,
    required this.initialBedtime,
  }) : super(key: key);

  @override
  _BedtimePickerDialogState createState() => _BedtimePickerDialogState();
}

class _BedtimePickerDialogState extends State<BedtimePickerDialog> {
  late TimeOfDay bedtime;

  @override
  void initState() {
    super.initState();
    bedtime = widget.initialBedtime;
  }

  Future<void> _showCupertinoTimePicker(BuildContext context) async {
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
                  use24hFormat: true,
                  initialDateTime: DateTime(
                    2020,
                    1,
                    1,
                    bedtime.hour,
                    bedtime.minute,
                  ),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      bedtime = TimeOfDay.fromDateTime(newDateTime);
                    });
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
        bedtime = pickedTime;
      });
    }
  }

  Future<void> _scheduleBedtimeNotification() async {
  final DateTime now = DateTime.now();
  final DateTime bedtimeToday = DateTime(
    now.year,
    now.month,
    now.day,
    bedtime.hour,
    bedtime.minute,
  );

  // Set the notification time to one hour earlier than the selected bedtime
  DateTime notificationTime = bedtimeToday.subtract(const Duration(hours: 1));

  // If the calculated notification time is in the past, schedule it for the next day
  if (notificationTime.isBefore(now)) {
    notificationTime = notificationTime.add(const Duration(days: 1));
  }

  await NotificationService.scheduleNotification(
    "Bedtime Reminder",
    "It's almost time to sleep! Get ready to unwind.",
    notificationTime,
  );

  // Show confirmation
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Bedtime reminder has been set for 1 hour before your bedtime')),
  );
}


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Bedtime'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCupertinoTimePicker(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                backgroundColor: const Color(0xFF272D42),
              ),
              child: Text(
                'Bedtime: ${bedtime.hour.toString().padLeft(2, '0')}:${bedtime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await _scheduleBedtimeNotification();
            Navigator.of(context).pop();
          },
          child: const Text('Set Bedtime'),
        ),
      ],
    );
  }
}