import 'package:flutter/material.dart';

class ToggleOption extends StatefulWidget {
  final String title;

  const ToggleOption({Key? key, required this.title}) : super(key: key);

  @override
  _ToggleOptionState createState() => _ToggleOptionState();
}

class _ToggleOptionState extends State<ToggleOption> {
  bool isOn = false;
  TimeOfDay time = const TimeOfDay(hour: 22, minute: 0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isOn) {
          final newTime = await showTimePicker(
            context: context,
            initialTime: time,
          );
          if (newTime != null) {
            setState(() => time = newTime);
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
            if (isOn)
              Text(
                time.format(context),
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
