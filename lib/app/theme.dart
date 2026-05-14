import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SinggahTheme {
  // Brand Colors from Design System
  static const Color primary = Color(0xFF134729);
  static const Color primaryContainer = Color(0xFF2D5F3F);
  static const Color onPrimaryContainer = Color(0xFFA1D7AE);
  
  static const Color secondary = Color(0xFF9D431C);
  static const Color secondaryContainer = Color(0xFFFE8C60);
  
  static const Color surface = Color(0xFFF8FAF5);
  static const Color onSurface = Color(0xFF191C19);
  static const Color surfaceContainerHighest = Color(0xFFE1E3DE);
  static const Color onSurfaceVariant = Color(0xFF414942);
  
  static const Color outline = Color(0xFF717971);
  static const Color outlineVariant = Color(0xFFC0C9BF);

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: Colors.white,
        secondaryContainer: secondaryContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 40 / 32,
          color: onSurface,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          height: 32 / 26,
          color: onSurface,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 28 / 20,
          color: onSurface,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          height: 24 / 17,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 24 / 16,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          height: 22 / 15,
          color: onSurface,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          height: 18 / 13,
          color: onSurfaceVariant,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 16 / 11,
          color: onSurfaceVariant,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    // Implement dark theme based on the same logic if needed
    return lightTheme; // For now, focus on light theme as per provided UI
  }
}
