import 'package:flutter/material.dart';
import '/themes/color_schemes.g.dart';

class Themes {
  Themes._();

  // ── Dark — deep navy + BTD6 orange ────────────────────────────────────────
  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme.copyWith(
      // Step up the surface container ladder from the base surface (#0F1923)
      surfaceContainerLowest: const Color(0xFF0B1219),
      surfaceContainerLow: const Color(0xFF141F2B),
      surfaceContainer: const Color(0xFF1A2737),
      surfaceContainerHigh: const Color(0xFF1E2D40),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F1923),
    cardTheme: CardThemeData(
      surfaceTintColor: Colors.transparent,
      color: const Color(0xFF1A2737),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: darkColorScheme.primary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0F1923),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 2,
      titleTextStyle: TextStyle(
        color: darkColorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF141F2B),
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      indicatorColor: darkColorScheme.primaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: darkColorScheme.primary);
        }
        return IconThemeData(color: darkColorScheme.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: darkColorScheme.primary,
          );
        }
        return TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: darkColorScheme.onSurfaceVariant,
        );
      }),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    dividerTheme: DividerThemeData(
      color: darkColorScheme.outline.withValues(alpha: 0.3),
      thickness: 1,
    ),
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      shape: const StadiumBorder(),
      backgroundColor: darkColorScheme.primaryContainer,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all<double>(2),
        iconColor: WidgetStateProperty.all(darkColorScheme.onSurface),
        foregroundColor: WidgetStateProperty.all(darkColorScheme.onSurface),
        backgroundColor:
            WidgetStateProperty.all(darkColorScheme.primaryContainer),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all(darkColorScheme.onSurface),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          const Color(0xFF1A2737),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    ),
  );

  // ── Light — warm parchment + deep amber ───────────────────────────────────
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme.copyWith(
      surfaceContainerLowest: const Color(0xFFFFFDF8),
      surfaceContainerLow: const Color(0xFFFFF3E4),
      surfaceContainer: const Color(0xFFF8ECD8),
      surfaceContainerHigh: const Color(0xFFF1E4CC),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFF8F0),
    cardTheme: CardThemeData(
      surfaceTintColor: Colors.transparent,
      color: const Color(0xFFFFFFFF),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: lightColorScheme.outline.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFFFF8F0),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 2,
      titleTextStyle: TextStyle(
        color: lightColorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFFFFFFF),
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      indicatorColor: lightColorScheme.primaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: lightColorScheme.primary);
        }
        return IconThemeData(color: lightColorScheme.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: lightColorScheme.primary,
          );
        }
        return TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: lightColorScheme.onSurfaceVariant,
        );
      }),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    dividerTheme: DividerThemeData(
      color: lightColorScheme.outline.withValues(alpha: 0.3),
      thickness: 1,
    ),
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      shape: const StadiumBorder(),
      backgroundColor: lightColorScheme.primaryContainer,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all<double>(2),
        iconColor: WidgetStateProperty.all(lightColorScheme.onSurface),
        foregroundColor: WidgetStateProperty.all(lightColorScheme.onSurface),
        backgroundColor:
            WidgetStateProperty.all(lightColorScheme.primaryContainer),
      ),
    ),
    iconTheme: IconThemeData(color: lightColorScheme.onSurface),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor:
            WidgetStateProperty.all(const Color(0xFFFFFFFF)),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    ),
  );
}
