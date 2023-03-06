import 'package:baby_tracker/themes/colors.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColorScheme
        .red, // This isn't really the color it should ever be, use .copyWith() method to set the proper color
  );
}
