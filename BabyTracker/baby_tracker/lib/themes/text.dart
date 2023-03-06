import 'package:baby_tracker/themes/colors.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColorScheme
        .red, // This isn't really the color it should ever be, use .copyWith() method to set the proper color
  );
  static const h1 = TextStyle(
    fontSize: 30,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    color: AppColorScheme
        .red, // This isn't really the color it should ever be, use .copyWith() method to set the proper color
  );
  static const h2 = TextStyle(
    fontSize: 26,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: AppColorScheme
        .red, // This isn't really the color it should ever be, use .copyWith() method to set the proper color
  );
}
