import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //Dark Theme Colors 
  static const Color backgroundColor = Color(0xFF0D0221);
  static const Color primarySurface = Color(0xFF261447);
  static const Color primaryAccent = Color(0xFFFF3864);
  static const Color secondaryAccent = Color(0xFF00C49A);
  static const Color textColor = Color(0xFFF0F0F0);

  //Light Theme Colors
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color lightPrimarySurface = Color(0xFFFFFFFF);
  static const Color lightPrimaryAccent = Color(0xFFE91E63);
  static const Color lightSecondaryAccent = Color(0xFF009688);
  static const Color lightTextColor = Color(0xFF121212);


  //Dark Theme Definition
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor, 
    primaryColor: primaryAccent,            
    colorScheme: const ColorScheme.dark(
      primary: primaryAccent,
      secondary: secondaryAccent,
      surface: primarySurface,
      onPrimary: textColor,
      onSecondary: textColor,
      onSurface: textColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
        .apply(bodyColor: textColor, displayColor: textColor),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryAccent,
      inactiveTrackColor: primarySurface.withOpacity(0.5),
      thumbColor: primaryAccent,
      overlayColor: primaryAccent.withAlpha(80),
    ),
    iconTheme: const IconThemeData(color: textColor),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primarySurface,
      selectedItemColor: primaryAccent,
      unselectedItemColor: textColor,
    )
  );

  //Light Theme Definition
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackgroundColor,
    primaryColor: lightPrimaryAccent,
    colorScheme: const ColorScheme.light(
      primary: lightPrimaryAccent,
      secondary: lightSecondaryAccent,
      surface: lightPrimarySurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: lightTextColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme)
        .apply(bodyColor: lightTextColor, displayColor: lightTextColor),
     sliderTheme: SliderThemeData(
      activeTrackColor: lightPrimaryAccent,
      inactiveTrackColor: lightPrimaryAccent.withOpacity(0.3),
      thumbColor: lightPrimaryAccent,
      overlayColor: lightPrimaryAccent.withAlpha(80),
    ),
    iconTheme: const IconThemeData(color: lightTextColor),
     appBarTheme: const AppBarTheme(
      backgroundColor: lightBackgroundColor,
      iconTheme: IconThemeData(color: lightTextColor), 
      titleTextStyle: TextStyle(color: lightTextColor, fontSize: 20, fontWeight: FontWeight.w500) 
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightPrimarySurface,
      selectedItemColor: lightPrimaryAccent,
      unselectedItemColor: Colors.grey,
    )
  );

  //Neumorphic
  static BoxDecoration neumorphicDecoration({
    double borderRadius = 15.0,
    Offset offset = const Offset(4, 4),
    
    required Brightness brightness,
  }) {
    final bool isDarkMode = brightness == Brightness.dark;
    
    return BoxDecoration(
      color: isDarkMode ? primarySurface : primarySurface,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: isDarkMode ? Colors.black.withOpacity(0.4) :  Colors.black.withOpacity(0.4),
          offset: offset,
          blurRadius: 8,
        ),
        BoxShadow(
          color: isDarkMode ?  Colors.black.withOpacity(0.4):  Colors.black.withOpacity(0.4),
          offset: -offset,
          blurRadius: 8,
        ),
      ],
    );
  }
}