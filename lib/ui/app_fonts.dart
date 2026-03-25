import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide font configuration derived from the tally counter design.
///
/// - [logoStyle]: Raleway with wide letter-spacing — used for all general UI text.
/// - [typewriterStyle]: Courier Prime — used for counter values, file titles,
///   and save-status text.
class AppFonts {
  AppFonts._();

  static TextStyle logoStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double letterSpacing = 1.2,
  }) {
    return GoogleFonts.raleway(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle typewriterStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return GoogleFonts.courierPrime(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Returns a Material [TextTheme] with Raleway as the base font.
  static TextTheme materialTextTheme(TextTheme base) {
    return GoogleFonts.ralewayTextTheme(base);
  }
}
