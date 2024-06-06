import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  //final Function() onPressed;

  const MyButton({
    Key? key,
    //required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(const Color.fromRGBO(106, 123, 255, 1)),
          fixedSize: MaterialStateProperty.all(const Size(300, 50)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontFamily: 'Unifont Smooth'),
        ),
      ),
    );
  }
}
