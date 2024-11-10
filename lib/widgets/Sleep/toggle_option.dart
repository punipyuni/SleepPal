import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleOption extends StatefulWidget {
  final String title;
  final bool isSleepTime;
  final VoidCallback onToggle;
  final TimeOfDay? displayTime; // Time to display below the title

  const ToggleOption({
    Key? key,
    required this.title,
    this.isSleepTime = false,
    required this.onToggle,
    this.displayTime,
  }) : super(key: key);

  @override
  _ToggleOptionState createState() => _ToggleOptionState();
}

class _ToggleOptionState extends State<ToggleOption> {
  bool isOn = false;

  String _formatTo24Hour(TimeOfDay? time) {
    if (time == null) return '--:--';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isOn) {
          widget.onToggle();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF272D42),
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
                  onChanged: (value) {
                    setState(() => isOn = value);
                    if (isOn) widget.onToggle();
                  },
                  activeColor: const Color(0xFF6A7BFF),
                ),
              ],
            ),
            if (isOn)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Time Set: ${_formatTo24Hour(widget.displayTime)}', // Display the set time
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
