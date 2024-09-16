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
    cardTheme: CardTheme(
      elevation: 5,
      shadowColor: Colors.black,
      color: darkColorScheme.primaryContainer,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all<double>(2),
        iconColor: WidgetStateProperty.all(
          darkColorScheme.onSurface,
        ),
        foregroundColor: WidgetStateProperty.all(
          darkColorScheme.onSurface,
        ),
        backgroundColor: WidgetStateProperty.all(
          darkColorScheme.primaryContainer,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all(
          darkColorScheme.onSurface,
        ),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(
        darkColorScheme.surface,
      )),
      inputDecorationTheme: const InputDecorationTheme(
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
    cardTheme: CardTheme(
      elevation: 5,
      shadowColor: Colors.black,
      color: lightColorScheme.primaryContainer,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all<double>(2),
        iconColor: WidgetStateProperty.all(
          lightColorScheme.onSurface,
        ),
        foregroundColor: WidgetStateProperty.all(
          lightColorScheme.onSurface,
        ),
        backgroundColor: WidgetStateProperty.all(
          lightColorScheme.primaryContainer,
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: lightColorScheme.onSurface,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(
        lightColorScheme.surface,
      )),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    ),
  );
}
