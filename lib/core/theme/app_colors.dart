import 'package:flutter/material.dart';

/// Centralized FinHub color palette for the application design system.
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color transparent = Color(0x00000000);
  static const Color overlay = Color(0x14000000);

  /// Backward-compatible aliases for screens that predate the FinHub shell.
  static const Color accent = primary;
  static const Color accentDark = Color(0xFF4338CA);
  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color textMuted = Color(0xFF9CA3AF);
}
