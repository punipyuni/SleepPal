import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../widgets/Sleep/sleep_header.dart';
import '../widgets/Sleep/bedtime_reminder_toggle.dart';
import '../widgets/Sleep/sleep_time_toggle.dart';
import '../widgets/Sleep/timer_display.dart';
import '../widgets/Sleep/relaxing_sound_option.dart';
import '../widgets/bottom_nav_bar.dart';
import '../utils/app_color.utils.dart';
import '../widgets/Sleep/time_range_picker.dart';

class SleepScreen extends StatefulWidget {
  final TimeOfDay? bedtimeReminder;

  const SleepScreen({super.key, this.bedtimeReminder});

  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  int _selectedIndex = 2;
  TimeOfDay? bedtimeReminder;
  TimeOfDay? sleepTime;

  @override
  void initState() {
    super.initState();
    bedtimeReminder = widget.bedtimeReminder;
    if (bedtimeReminder != null) {
      _scheduleBedtimeNotification(bedtimeReminder!);
    }
  }

  Future<void> _showTimeRangePicker({required bool isBedtimeReminder}) async {
    final result = await showDialog<List<TimeOfDay>>(
      context: context,
      builder: (context) {
        return TimeRangePickerDialog(
          initialStartTime: (isBedtimeReminder ? bedtimeReminder : sleepTime) ?? TimeOfDay.now(),
          initialEndTime: TimeOfDay(hour: 0, minute: 0),
          isNotificationPicker: isBedtimeReminder,
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      final selectedTime = result[0];
      final adjustedHour = (selectedTime.hour - 1) < 0 ? 23 : selectedTime.hour - 1;
      setState(() {
        if (isBedtimeReminder) {
          bedtimeReminder = TimeOfDay(hour: adjustedHour, minute: selectedTime.minute);
          _scheduleBedtimeNotification(bedtimeReminder!);
        } else {
          sleepTime = TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute);
        }
      });
    }
  }

  Future<void> _scheduleBedtimeNotification(TimeOfDay bedtimeReminder) async {
    final DateTime now = DateTime.now();
    final DateTime notificationTime = DateTime(
      now.year,
      now.month,
      now.day,
      bedtimeReminder.hour,
      bedtimeReminder.minute,
    );

    print("Scheduled bedtime reminder at: $notificationTime");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VStack(
              [
                SleepHeader().pOnly(bottom: 20),
                BedtimeReminderToggle(
                  onToggle: () => _showTimeRangePicker(isBedtimeReminder: true),
                  reminderTime: bedtimeReminder, // Pass the bedtime reminder time
                ),
                const Spacer(),
                TimerDisplay(),
                const Spacer(),
                RelaxingSoundOption(),
              ],
              crossAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
      ),
    );
  }
}
