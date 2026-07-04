import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

/// Root FinHub application widget configured with router-based navigation.
class FinHubApp extends StatelessWidget {
  const FinHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FinHub',
      theme: FinHubTheme.light,
      routerConfig: appRouter,
    );
  }
}


