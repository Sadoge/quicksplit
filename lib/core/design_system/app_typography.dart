import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static TextStyle get displayLarge => GoogleFonts.nunito(
        fontSize: 52,
        fontWeight: FontWeight.w600,
        letterSpacing: -2.0,
      );

  static TextStyle get displaySmall => GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
      );

  static TextStyle get titleLarge => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get titleMedium => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get labelLarge => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get labelSmall => GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
      );

  static TextStyle get mono => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get monoLarge => GoogleFonts.jetBrainsMono(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );
}
