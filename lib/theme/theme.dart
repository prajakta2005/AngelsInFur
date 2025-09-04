// lib/theme/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color lightPrimary = Color(0xFFFA7A1E); // from your logo
final Color darkPrimary = Color(0xFF121212);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: lightPrimary,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: lightPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: darkPrimary,
  scaffoldBackgroundColor: Color(0xFF1E1E1E),
  appBarTheme: AppBarTheme(
    backgroundColor: darkPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.dark().textTheme,
  ),
);
