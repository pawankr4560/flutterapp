import 'package:flutter/material.dart';

import 'package:finhub/app/theme.dart';

/// Shared spacing tokens used by legacy and FinHub widgets.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Compatibility wrapper that exposes the FinHub light theme.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => FinHubTheme.light;
}


