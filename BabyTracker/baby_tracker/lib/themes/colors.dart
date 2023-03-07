import 'package:flutter/material.dart';

// List of all available themes. Enum for easier expansion.
enum Themes { light, dark }

// Light colors
// Yes, I know that the style is weird. Yes, I'll get around to putting it all in hex at some point -April
class AppColorScheme {
  static const Color black = Color(0xFF222222);
  static const Color darkGray = Color.fromARGB(255, 70, 70, 70);
  static const Color lightGray = Color.fromARGB(255, 194, 193, 193);
  static const Color white = Color(0xFFDDDDDD);
  static const Color purple = Color.fromARGB(255, 172, 21, 172);
  static const Color red = Color.fromARGB(255, 185, 56, 39);
  static const Color paleRed = Color(0xffee4c83);
  static const Color blue = Color.fromARGB(255, 43, 114, 172);
  static const Color paleBlue = Color(0xffb5dcfb);
  static const Color yellow = Color(0xffffa014);
  static const Color paleYellow = Color(0xfffff389);
  static const Color green = Color(0xff47a44b);
  static const Color paleGreen = Color(0xffaddbaf);
  static const Color pink = Color.fromARGB(255, 219, 50, 109);
  static const Color palePink = Color(0xFFF8BBD0);
}

class AppThemes with ChangeNotifier {
  // ignore: prefer_final_fields
  static ThemeMode _darkOrLightMode = ThemeMode.system;
  ThemeMode get currentTheme => _darkOrLightMode;

  static final ThemeData lightMode = ThemeData(
    primaryColor: AppColorScheme.black,
    scaffoldBackgroundColor: AppColorScheme.white,
    disabledColor: AppColorScheme.lightGray,
    textTheme: const TextTheme(
      bodyLarge:
          TextStyle(fontSize: 40, height: 2.0, color: AppColorScheme.black),
      bodyMedium:
          TextStyle(fontSize: 30, height: 1.5, color: AppColorScheme.black),
      bodySmall:
          TextStyle(fontSize: 20, height: 1.15, color: AppColorScheme.black),
      titleLarge:
          TextStyle(fontSize: 60, height: 3.0, color: AppColorScheme.black),
      titleMedium:
          TextStyle(fontSize: 50, height: 2.5, color: AppColorScheme.black),
      titleSmall:
          TextStyle(fontSize: 45, height: 2.25, color: AppColorScheme.black),
    ),
  );

  static final ThemeData darkMode = ThemeData(
    primaryColor: AppColorScheme.white,
    scaffoldBackgroundColor: AppColorScheme.black,
    disabledColor: AppColorScheme.darkGray,
    textTheme: const TextTheme(
      bodyLarge:
          TextStyle(fontSize: 40, height: 2.0, color: AppColorScheme.lightGray),
      bodyMedium:
          TextStyle(fontSize: 30, height: 1.5, color: AppColorScheme.lightGray),
      bodySmall: TextStyle(
          fontSize: 20, height: 1.15, color: AppColorScheme.lightGray),
      titleLarge:
          TextStyle(fontSize: 60, height: 3.0, color: AppColorScheme.lightGray),
      titleMedium:
          TextStyle(fontSize: 50, height: 2.5, color: AppColorScheme.lightGray),
      titleSmall: TextStyle(
          fontSize: 45, height: 2.25, color: AppColorScheme.lightGray),
    ),
  );
}
