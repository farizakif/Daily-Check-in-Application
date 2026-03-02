import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF0D1B2A);
  static const Color _accentColor = Color(0xFF00C9A7);
  static const Color _backgroundColor = Color(0xFFF4F6F9);

  // Public accessors for cross-layer theming without exposing internals.
  static const Color primaryColor = _primaryColor;
  static const Color accentColor = _accentColor;
  static const Color backgroundColor = _backgroundColor;

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      primary: _primaryColor,
      secondary: _accentColor,
    ).copyWith(surface: _backgroundColor);

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _backgroundColor,
    );

    final textTheme = GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
      headlineLarge: GoogleFonts.sora(textStyle: base.textTheme.headlineLarge),
      headlineMedium: GoogleFonts.sora(
        textStyle: base.textTheme.headlineMedium,
      ),
      headlineSmall: GoogleFonts.sora(textStyle: base.textTheme.headlineSmall),
      titleLarge: GoogleFonts.sora(textStyle: base.textTheme.titleLarge),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.sora(
          textStyle: base.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.05),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
