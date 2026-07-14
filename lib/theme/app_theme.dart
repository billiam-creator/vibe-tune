import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VibeTuneTheme {
  static const Color background = Color(0xFF050505);
  static const Color surface = Color(0xFF0D0D0D);
  static const Color card = Color(0xFF111111);
  static const Color cardBorder = Color(0xFF1E1E1E);
  static const Color primary = Color(0xFFFF3D00); // fiery orange-red
  static const Color accent = Color(0xFFFFD600); // golden yellow
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF999999);
  static const Color textMuted = Color(0xFF555555);
  static const Color divider = Color(0xFF1A1A1A);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        background: background,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
          ),
          displayMedium: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
          ),
          displaySmall: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
          headlineLarge: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: textSecondary),
          bodyMedium: TextStyle(color: textSecondary),
          labelLarge: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dividerColor: divider,
      useMaterial3: true,
    );
  }
}
