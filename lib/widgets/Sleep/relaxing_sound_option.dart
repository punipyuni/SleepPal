import 'package:flutter/material.dart';
import 'package:sleeppal_update/pages/Relax.dart';
import '../../pages/ASMR.dart';

class RelaxingSoundOption extends StatelessWidget {
  const RelaxingSoundOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16), 
      decoration: BoxDecoration(
        color: Color(0xFF272D42),
        borderRadius: BorderRadius.circular(18),
      ),
      child: GestureDetector(
        onTap: () {
          // Navigate to RelaxingSoundPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RelaxingMusic()),
          );
        },
        child: const Row(
          children: [
            Icon(Icons.music_note, color: Colors.blue),
            SizedBox(width: 16),
            Text(
              'Relaxing Sound',
              style: TextStyle(color: Colors.white),
            ),
            Spacer(),
            Icon(Icons.grid_view, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
