import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Main color palette - soft pastels with glowy feel
  static const Color _primaryColor = Color(0xFF9370DB); // Medium purple
  static const Color _secondaryColor = Color(0xFFB19CD9); // Light purple
  static const Color _accentColor = Color(0xFFFF85A2);   // Soft pink
  static const Color _backgroundColor = Color(0xFFF8F6FF); // Very light purple/lavender
  static const Color _surfaceColor = Colors.white;
  static const Color _errorColor = Color(0xFFFF6B6B);
  
  // Text colors
  static const Color _onPrimaryColor = Colors.white;
  static const Color _onSecondaryColor = Color(0xFF2D2D2D);
  static const Color _onBackgroundColor = Color(0xFF2D2D2D);
  static const Color _onSurfaceColor = Color(0xFF2D2D2D);
  static const Color _onErrorColor = Colors.white;

  // Dark mode colors
  static const Color _darkPrimaryColor = Color(0xFFB19CD9);
  static const Color _darkSecondaryColor = Color(0xFF9370DB);
  static const Color _darkBackgroundColor = Color(0xFF1A1625); // Dark purple-black
  static const Color _darkSurfaceColor = Color(0xFF2D253A); // Dark purple-gray

  // Shadow and glow effects
  static List<BoxShadow> get softGlow => [
    BoxShadow(
      color: _primaryColor.withOpacity(0.15),
      blurRadius: 15,
      spreadRadius: 1,
    ),
  ];
  
  static List<BoxShadow> get cardGlow => [
    BoxShadow(
      color: _primaryColor.withOpacity(0.1),
      blurRadius: 10,
      spreadRadius: 1,
      offset: const Offset(0, 2),
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _accentColor,
        surface: _surfaceColor,
        background: _backgroundColor,
        error: _errorColor,
        onPrimary: _onPrimaryColor,
        onSecondary: _onSecondaryColor,
        onSurface: _onSurfaceColor,
        onBackground: _onBackgroundColor,
        onError: _onErrorColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: _backgroundColor,
      textTheme: GoogleFonts.nunitoTextTheme(
        ThemeData.light().textTheme,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: _onPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 4,
          shadowColor: _primaryColor.withOpacity(0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _primaryColor.withOpacity(0.3), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _primaryColor.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: _surfaceColor,
        shadowColor: _primaryColor.withOpacity(0.2),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _backgroundColor,
        foregroundColor: _onBackgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: _onBackgroundColor,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 24),
        selectedItemColor: _primaryColor,
        unselectedItemColor: Color(0xFFBBBBBB),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        tertiary: _accentColor,
        surface: _darkSurfaceColor,
        background: _darkBackgroundColor,
        error: _errorColor,
        onPrimary: _onSurfaceColor,
        onSecondary: _onPrimaryColor,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: _onErrorColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: _darkBackgroundColor,
      textTheme: GoogleFonts.nunitoTextTheme(
        ThemeData.dark().textTheme,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimaryColor,
          foregroundColor: _onSurfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 4,
          shadowColor: _darkPrimaryColor.withOpacity(0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkPrimaryColor,
          side: const BorderSide(color: _darkPrimaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _darkPrimaryColor.withOpacity(0.3), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _darkPrimaryColor.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _darkPrimaryColor, width: 2),
        ),
        filled: true,
        fillColor: Color(0xFF3D3553), // Slightly lighter than surface
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: _darkSurfaceColor,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _darkBackgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: _darkSurfaceColor,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 24),
        selectedItemColor: _darkPrimaryColor,
        unselectedItemColor: Color(0xFF8A8A8A),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _darkSurfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Helper method to get container decoration with glow
  static BoxDecoration get glowingContainer => BoxDecoration(
    color: _surfaceColor,
    borderRadius: BorderRadius.circular(24),
    boxShadow: softGlow,
  );
  
  static BoxDecoration get darkGlowingContainer => BoxDecoration(
    color: _darkSurfaceColor,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: _darkPrimaryColor.withOpacity(0.15),
        blurRadius: 15,
        spreadRadius: 1,
      ),
    ],
  );
}