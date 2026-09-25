import 'package:flutter/material.dart';

/// NextStopGuides brand palette: ocean teal, deep sea blue, sunset orange
/// and warm sand - a classic travel look.
class BrandColors {
  BrandColors._();

  static const Color ocean = Color(0xFF0E7C86);
  static const Color deepSea = Color(0xFF0B3C5D);
  static const Color sunset = Color(0xFFFF7A45);
  static const Color sunsetDark = Color(0xFFE85D2A);
  static const Color sand = Color(0xFFF6E7C8);
  static const Color palm = Color(0xFF2E9E6A);
  static const Color coral = Color(0xFFE5484D);

  static const Color gold = Color(0xFFE7B622);
  static const Color silver = Color(0xFFA8B2BD);
  static const Color bronze = Color(0xFFB87333);

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [deepSea, ocean],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [sunsetDark, sunset, Color(0xFFFFB347)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(
        ColorScheme.fromSeed(
          seedColor: BrandColors.ocean,
          secondary: BrandColors.sunset,
          brightness: Brightness.light,
        ),
      );

  static ThemeData dark() => _build(
        ColorScheme.fromSeed(
          seedColor: BrandColors.ocean,
          secondary: BrandColors.sunset,
          brightness: Brightness.dark,
        ),
      );

  static ThemeData _build(ColorScheme scheme) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: shape,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: shape,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
