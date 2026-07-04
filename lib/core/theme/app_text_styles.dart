import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable Poppins typography scale for FinHub.
class AppTextStyles {
  const AppTextStyles._();

  static TextStyle displayLarge(BuildContext context) =>
      _base(context).displayLarge!;

  static TextStyle displayMedium(BuildContext context) =>
      _base(context).displayMedium!;

  static TextStyle headlineLarge(BuildContext context) =>
      _base(context).headlineLarge!;

  static TextStyle headlineMedium(BuildContext context) =>
      _base(context).headlineMedium!;

  static TextStyle titleLarge(BuildContext context) =>
      _base(context).titleLarge!;

  static TextStyle titleMedium(BuildContext context) =>
      _base(context).titleMedium!;

  static TextStyle bodyLarge(BuildContext context) => _base(context).bodyLarge!;

  static TextStyle bodyMedium(BuildContext context) =>
      _base(context).bodyMedium!;

  static TextStyle bodySmall(BuildContext context) => _base(context).bodySmall!;

  static TextStyle labelLarge(BuildContext context) =>
      _base(context).labelLarge!;

  /// Builds the Material text theme with colors inherited from the active theme.
  static TextTheme theme(ColorScheme colorScheme) {
    final textColor = colorScheme.onSurface;
    final secondaryColor = colorScheme.onSurfaceVariant;

    return GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        color: textColor,
        fontSize: 57,
        fontWeight: FontWeight.w700,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.poppins(
        color: textColor,
        fontSize: 45,
        fontWeight: FontWeight.w700,
        height: 1.16,
      ),
      headlineLarge: GoogleFonts.poppins(
        color: textColor,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: textColor,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.28,
      ),
      titleLarge: GoogleFonts.poppins(
        color: textColor,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      titleMedium: GoogleFonts.poppins(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.45,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: secondaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.poppins(
        color: secondaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      labelLarge: GoogleFonts.poppins(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    );
  }

  static TextTheme _base(BuildContext context) => Theme.of(context).textTheme;
}


