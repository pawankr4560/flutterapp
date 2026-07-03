import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initializeDeepLinks();
  }

  void _initializeDeepLinks() {
    _linkSubscription = _appLinks.uriLinkStream.listen(_handleDeepLink);
  }

  void _handleDeepLink(Uri uri) {
    if (!mounted || uri.scheme != 'loantracker') {
      return;
    }

    final isLoginLink = uri.host == 'login' || uri.path == AppRoutePaths.login;
    final emailConfirmed = uri.queryParameters['emailConfirmed'];
    if (!isLoginLink || (emailConfirmed != 'true' && emailConfirmed != 'false')) {
      return;
    }

    _router.go(
      Uri(
        path: AppRoutePaths.login,
        queryParameters: {
          'emailConfirmed': emailConfirmed,
          'messageId': DateTime.now().microsecondsSinceEpoch.toString(),
        },
      ).toString(),
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _router.dispose();
    super.dispose();
  }

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
