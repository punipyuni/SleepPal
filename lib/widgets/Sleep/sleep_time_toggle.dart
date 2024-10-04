import 'package:flutter/material.dart';
import 'toggle_option.dart';

class SleepTimeToggle extends StatelessWidget {
  const SleepTimeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ToggleOption(title: 'Sleep time');
  }
}