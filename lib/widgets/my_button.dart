import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MyButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(300, 50),
          backgroundColor: const Color.fromRGBO(106, 123, 255, 1),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(text,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Unifont Smooth',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ),
    );
  }
}
