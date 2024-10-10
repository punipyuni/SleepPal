import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/sleep/sleep_header.dart';
import '../../widgets/sleep/bedtime_reminder_toggle.dart';
import '../../widgets/sleep/sleep_time_toggle.dart';
import '../../widgets/sleep/timer_display.dart';
import '../../widgets/sleep/relaxing_sound_option.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../utils/app_color.utils.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
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
                BedtimeReminderToggle().pOnly(bottom: 18),
                SleepTimeToggle().pOnly(bottom: 40),
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
