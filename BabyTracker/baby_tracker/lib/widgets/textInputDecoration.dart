import 'package:baby_tracker/themes/colors.dart';
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle:
      TextStyle(color: AppColorScheme.black, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColorScheme.blue, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColorScheme.blue, width: 2),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColorScheme.paleBlue, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColorScheme.red, width: 2),
  ),
);
