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
          darkColorScheme.onBackground,
        ),
        foregroundColor: MaterialStateProperty.all(
          darkColorScheme.onBackground,
        ),
        backgroundColor: MaterialStateProperty.all(
          darkColorScheme.primaryContainer,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all(
          darkColorScheme.onBackground,
        ),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(
        darkColorScheme.background,
      )),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        // Use InputBorder.none to remove the default border.
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
          lightColorScheme.onBackground,
        ),
        foregroundColor: MaterialStateProperty.all(
          lightColorScheme.onBackground,
        ),
        backgroundColor: MaterialStateProperty.all(
          lightColorScheme.primaryContainer,
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: lightColorScheme.onBackground,
    ),
  );
}
