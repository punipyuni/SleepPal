import 'package:flutter/material.dart';

class AppColor {
  static const primaryButtonColor = Color(0xFF6A7BFF);
  static const alertButtonColor = Color(0xFFF43737);

  static const primaryBackgroundColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2C2C54), // Dark purple color
      Color(0xFF4B3E75), // Lighter purple at the top
      Color(0xFF000000), // Black at the bottom
    ],
  );
  static const subBackgroundColor = Color(0xFF24262E);

  static const navBarColor = Color(0xFF000000);
  static const navBarButtonColor = Color(0xFFD3D3D3);
}
