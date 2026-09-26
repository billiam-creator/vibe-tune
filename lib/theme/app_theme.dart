import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Matches the VibeTune Design System reference (dark-themed, high-contrast,
/// three-font type system) so the mobile app stays visually consistent with
/// the web app.
class VibeTuneTheme {
  // ---- 01. Brand & accent colors -------------------------------------
  static const Color primary = Color(0xFFDA121A); // Brand Red
  static const Color primaryHover = Color(0xFFFF3333); // Brand Red — Hover / pressed state
  static const Color accent = Color(0xFF3CE577); // Brand Green — success/active indicators
  static const Color accentHover = Color(0xFF2BD966); // Brand Green — Hover
  static const Color neonGreen = accentHover; // "NEW" tag — brighter green than RISING's accent
  static const Color lightPink = Color(0xFFFF8E9B); // Micro-animations, typography accents

  // ---- 02. Background layers -------------------------------------
  static const Color background = Color(0xFF070709); // App background (base)
  static const Color surface = Color(0xFF0A0A0C); // Card/container — secondary
  static const Color card = Color(0xFF0F0F12); // Card/container — elevated (modals, floating panels)
  static const Color sunken = Color(0xFF08080A); // Subtle sunken/inset elements
  static const List<Color> cardGradient = [Color(0xFF0A0A0D), Color(0xFF050505)];

  // ---- 03. Borders & separators -------------------------------------
  static const Color cardBorder = Color(0xFF272733); // Primary border
  static const Color divider = Color(0xFF09090B); // Darker separator (zinc-950)

  // ---- 04. Text colors -------------------------------------
  static const Color textPrimary = Color(0xFFF4F4F5); // zinc-100
  static const Color textSecondary = Color(0xFFA1A1AA); // zinc-400
  static const Color textMuted = Color(0xFF52525B); // zinc-600

  // ---- 05. Typography -------------------------------------
  // Anton — headers, always uppercase with tight/wide tracking per spec.
  static TextStyle h1({Color color = textPrimary}) => GoogleFonts.anton(
        color: color,
        fontSize: 48, // 48px mobile → 80px desktop in the web spec
        height: 0.85,
        letterSpacing: -0.5,
      );
  static TextStyle h2({Color color = textPrimary}) => GoogleFonts.anton(
        color: color,
        fontSize: 24,
        letterSpacing: 1.2,
      );
  static TextStyle h3({Color color = textPrimary}) => GoogleFonts.anton(
        color: color,
        fontSize: 20,
        letterSpacing: 1.5,
      );

  // Inter — body text.
  static TextStyle body({Color color = textSecondary}) => GoogleFonts.inter(
        color: color,
        fontSize: 15,
        letterSpacing: 0.2,
        height: 1.5,
      );
  static TextStyle bodySmall({Color color = textSecondary}) => GoogleFonts.inter(
        color: color,
        fontSize: 12,
        height: 1.4,
      );

  // JetBrains Mono — tags, badges, metadata.
  static TextStyle tag({Color color = textPrimary}) => GoogleFonts.jetBrainsMono(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
      );

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
      textTheme: TextTheme(
        // Anton — headers
        displayLarge: h1(),
        displayMedium: h2(),
        displaySmall: h3(),
        headlineLarge: h2(),
        headlineMedium: h3(),
        // Inter — body
        bodyLarge: body(),
        bodyMedium: body(),
        bodySmall: bodySmall(),
        // JetBrains Mono — tags/badges/metadata
        labelLarge: tag(),
        labelSmall: tag(color: textSecondary),
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