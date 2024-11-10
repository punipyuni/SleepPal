import 'package:flutter/material.dart';

import 'app_color.utils.dart';

class AppTheme {
  static final sleepPalTheme = ThemeData(
    primaryColor: AppColor.primaryButtonColor,
    scaffoldBackgroundColor: AppColor.primaryBackgroundColor.colors[0],
    fontFamily: 'CarmenSans',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryButtonColor,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}