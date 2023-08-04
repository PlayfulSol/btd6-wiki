import 'package:flutter/material.dart';

class Themes {
  Themes._();
  static final darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[800],
    appBarTheme: AppBarTheme(
      color: Colors.grey[800],
    ),
    dividerColor: Colors.transparent,
  );

  static final lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: Colors.lightBlue[200],
    appBarTheme: AppBarTheme(
      color: Colors.lightBlue[200],
    ),
    dividerColor: Colors.transparent,
  );
}
