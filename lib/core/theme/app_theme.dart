import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    const backgroundColor = Color.fromRGBO(47, 81, 91, 1);
    final textTheme = GoogleFonts.rubikSprayPaintTextTheme().apply(
      displayColor: Colors.white,
      bodyColor: Colors.white,
    );
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: backgroundColor,
        primary: Colors.red,
        onPrimary: Colors.white,
        primaryContainer: Colors.yellow,
        onPrimaryContainer: backgroundColor,
      ),

      appBarTheme: AppBarTheme(
        color: backgroundColor,
      ),
    );
  }
}
