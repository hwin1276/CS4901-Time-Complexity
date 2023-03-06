import 'package:baby_tracker/themes/colors.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColorScheme
        .red, // This isn't really the color it should ever be, use .copyWith() method to set the proper color
  );
  // This one can be used as a title style for now (maybe just annotate that's why you're using it in a comment in that case)
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
  static const h3 = TextStyle(
    fontSize: 20,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    color: AppColorScheme
        .red, // This isn't really the color it should ever be, use .copyWith() method to set the proper color
  );
  static const subtitle = TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w100,
    color: AppColorScheme
        .red, // This isn't really the color it should ever be, use .copyWith() method to set the proper color
  );
}
