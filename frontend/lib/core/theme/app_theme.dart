import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF6C4DFF);
  static const Color secondaryColor = Color(0xFF8B5CFF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
      ),

      scaffoldBackgroundColor: const Color(0xFFF7F8FC),

      textTheme: GoogleFonts.interTextTheme(),

      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}