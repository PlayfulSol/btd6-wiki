import 'package:flutter/material.dart';
import '/themes/color_schemes.g.dart';

class Themes {
  Themes._();
  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    expansionTileTheme: const ExpansionTileThemeData(
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    expansionTileTheme: const ExpansionTileThemeData(
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
    ),
  );
}
