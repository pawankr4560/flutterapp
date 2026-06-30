import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const LoanTrackerApp());
}

class LoanTrackerApp extends StatefulWidget {
  const LoanTrackerApp({super.key});

  @override
  State<LoanTrackerApp> createState() => _LoanTrackerAppState();
}

class _LoanTrackerAppState extends State<LoanTrackerApp> {
  late final _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Loan Tracker',
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
