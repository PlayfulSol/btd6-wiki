import 'package:flutter/material.dart';
import '/utilities/themes.dart';

class GlobalState {
  GlobalState._();

  static String currentTitle = '';
  static ThemeData currentTheme = Themes.darkTheme;
  static bool isLoading = false;
}
