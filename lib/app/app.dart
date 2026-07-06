import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';
import 'theme_controller.dart';

/// Root SmartSathi application widget configured with router-based navigation.
class FinHubApp extends ConsumerWidget {
  const FinHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SmartSathi',
      theme: FinHubTheme.light,
      darkTheme: FinHubTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
