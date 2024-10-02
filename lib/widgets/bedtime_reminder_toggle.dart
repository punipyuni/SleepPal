import 'package:flutter/material.dart';
import '../widgets/toggle_option.dart';

class BedtimeReminderToggle extends StatelessWidget {
  const BedtimeReminderToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ToggleOption(title: 'Bedtime reminder');
  }
}