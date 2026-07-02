import 'package:flutter/material.dart';

import 'core/auth/auth_session.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthSession.instance.initialize();
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
