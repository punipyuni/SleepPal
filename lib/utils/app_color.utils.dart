import 'package:flutter/material.dart';

class AppColor {
  static const primaryButtonColor = Color(0xFF6A7BFF);
  static const alertButtonColor = Color(0xFFF43737);

  static const primaryBackgroundColor = RadialGradient(
    center: Alignment(-1.0, -0.8),
    radius: 1.3,
    colors: [
      Color(0xFF6C51A6),
      Color(0xFF1A102E),
      Color(0xFF131417),
    ],
    stops: [0.17, 0.56, 1.0],
  );
  static const subBackgroundColor = Color(0xFF24262E);

  static const navBarColor = Color(0xFF000000);
  static const navBarButtonColor = Color(0xFFD3D3D3);
}