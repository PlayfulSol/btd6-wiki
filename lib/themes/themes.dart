import 'package:flutter/material.dart';
import '/themes/color_schemes.g.dart';

class Themes {
  Themes._();
  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    expansionTileTheme: const ExpansionTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    cardTheme: const CardTheme(
      elevation: 5,
      shadowColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(2),
        iconColor: MaterialStateProperty.all(
          darkColorScheme.onPrimaryContainer,
        ),
        foregroundColor: MaterialStateProperty.all(
          darkColorScheme.onPrimaryContainer,
        ),
        backgroundColor: MaterialStateProperty.all(
          darkColorScheme.primaryContainer,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor:
            MaterialStateProperty.all(darkColorScheme.onPrimaryContainer),
      ),
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    expansionTileTheme: const ExpansionTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    cardTheme: const CardTheme(
      elevation: 5,
      shadowColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(2),
        iconColor: MaterialStateProperty.all(
          lightColorScheme.onPrimaryContainer,
        ),
        foregroundColor: MaterialStateProperty.all(
          lightColorScheme.onPrimaryContainer,
        ),
        backgroundColor: MaterialStateProperty.all(
          lightColorScheme.primaryContainer,
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: lightColorScheme.onPrimaryContainer,
    ),
  );
}
