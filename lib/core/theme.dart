import 'package:flutter/material.dart';

/// Centralised colour definitions for the OLOSI social demo. These values
/// originate from the provided design spec and ensure consistent use of
/// colour across the application. See README or design prompt for
/// background on these choices.
class OlosiColors {
  static const primary = Color(0xFF45C8BE);
  static const primaryDark = Color(0xFF39A49C);
  static const primaryLight = Color(0xFF74D6CE);
  static const surface = Color(0xFFDEF5F3);
  static const surfaceAlt = Color(0xFFC7EEEC);
  static const accent = Color(0xFF266E69);
  static const text = Color(0xFF0B2723);
  static const muted = Color(0xFF476E69);

  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFF6A700);
  static const danger = Color(0xFFD32F2F);
}

/// Builds the application theme using Material 3 (Material You) guidelines.
/// Colours and typographic styles are tuned to meet WCAG contrast
/// requirements. Checkboxes, cards and app bars are customised per the
/// specification.
ThemeData buildOlosiTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: OlosiColors.primary,
    onPrimary: OlosiColors.text,
    secondary: OlosiColors.accent,
    onSecondary: Colors.white,
    surface: OlosiColors.surface,
    onSurface: OlosiColors.text,
    background: OlosiColors.surfaceAlt,
    onBackground: OlosiColors.text,
    error: OlosiColors.danger,
    onError: Colors.white,
  );

  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: OlosiColors.surfaceAlt,
    useMaterial3: true,
    textTheme: const TextTheme(
      titleMedium:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0.06),
      bodyLarge: TextStyle(fontSize: 18, height: 1.35),
      bodyMedium: TextStyle(fontSize: 16, height: 1.35),
    ).apply(
      bodyColor: OlosiColors.text,
      displayColor: OlosiColors.text,
    ),
    checkboxTheme: CheckboxThemeData(
      side: const BorderSide(color: OlosiColors.accent, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      fillColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? OlosiColors.accent : Colors.transparent),
      checkColor: const WidgetStatePropertyAll<Color>(Colors.white),
    ),
    cardTheme: CardTheme(
      color: OlosiColors.surface,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: OlosiColors.primary,
      foregroundColor: OlosiColors.text,
      elevation: 0,
      centerTitle: true,
    ),
  );
}