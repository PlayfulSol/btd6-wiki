import 'package:flutter/material.dart';

// ── BTD6 Dark — "Monkey Kingdom Night" ──────────────────────────────────────
// Primary: BTD6 signature orange-gold
// Secondary: income green
// Tertiary: info blue
// Surface: deep navy

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Orange / gold — the BTD6 brand color
  primary: Color(0xFFF59C31),
  onPrimary: Color(0xFF3E1E00),
  primaryContainer: Color(0xFF5A3400),
  onPrimaryContainer: Color(0xFFFFD08A),

  // Income green
  secondary: Color(0xFF6DCF95),
  onSecondary: Color(0xFF003919),
  secondaryContainer: Color(0xFF005227),
  onSecondaryContainer: Color(0xFF8DEBB4),

  // Info sky-blue
  tertiary: Color(0xFF7EC8E3),
  onTertiary: Color(0xFF00364A),
  tertiaryContainer: Color(0xFF004E6A),
  onTertiaryContainer: Color(0xFFBDE9FF),

  // Error
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),

  // Deep navy surfaces
  surface: Color(0xFF0F1923),
  onSurface: Color(0xFFE0D8CC),
  surfaceContainerHighest: Color(0xFF2F3E50),
  onSurfaceVariant: Color(0xFFB8ACA0),

  // Outlines (warm)
  outline: Color(0xFF86746A),
  outlineVariant: Color(0xFF3A2F28),

  // Inverse
  onInverseSurface: Color(0xFF0F1923),
  inverseSurface: Color(0xFFE0D8CC),
  inversePrimary: Color(0xFF8B5000),

  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFF59C31),
  scrim: Color(0xFF000000),
);

// ── BTD6 Light — "Monkey Kingdom Day" ───────────────────────────────────────
// Primary: deep amber — readable orange on cream
// Secondary: forest green
// Surface: warm parchment — like the game's scroll/achievement UI

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Deep amber (darkened orange for readability on light)
  primary: Color(0xFF9B5000),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFDDB0),
  onPrimaryContainer: Color(0xFF311500),

  // Forest green
  secondary: Color(0xFF1F6B43),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFA6F0C4),
  onSecondaryContainer: Color(0xFF00210F),

  // Deep sky blue
  tertiary: Color(0xFF005780),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFC4E8FF),
  onTertiaryContainer: Color(0xFF001E2E),

  // Error
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),

  // Warm parchment surfaces
  surface: Color(0xFFFFF8F0),
  onSurface: Color(0xFF1C1208),
  surfaceContainerHighest: Color(0xFFEDD8C2),
  onSurfaceVariant: Color(0xFF53443A),

  // Outlines (warm brown)
  outline: Color(0xFF85736A),
  outlineVariant: Color(0xFFD6C3B8),

  // Inverse
  onInverseSurface: Color(0xFFFFF8F0),
  inverseSurface: Color(0xFF332214),
  inversePrimary: Color(0xFFFFB870),

  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF9B5000),
  scrim: Color(0xFF000000),
);
