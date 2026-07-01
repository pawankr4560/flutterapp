import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/application/application_form_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/calculator/emi_calculator_screen.dart';
import '../../features/documents/document_upload_screen.dart';
import '../../features/home/dashboard_screen.dart';
import '../../features/home/nav_home_screen.dart';
import '../../features/status/application_status_screen.dart';

class AppRoutePaths {
  const AppRoutePaths._();

  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String loans = '/loans';
  static const String payments = '/payments';
  static const String profile = '/profile';
  static const String calculator = '/calculator';
  static const String apply = '/apply';
  static const String documents = '/documents';
  static const String status = '/status';
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutePaths.login,
    routes: [
      GoRoute(
        path: AppRoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => NavHomeScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutePaths.home,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutePaths.loans,
            builder: (context, state) => const _NavPlaceholder(title: 'Loans'),
          ),
          GoRoute(
            path: AppRoutePaths.payments,
            builder: (context, state) => const _NavPlaceholder(title: 'Payments'),
          ),
          GoRoute(
            path: AppRoutePaths.profile,
            builder: (context, state) => const _NavPlaceholder(title: 'Profile'),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutePaths.calculator,
        builder: (context, state) => const EmiCalculatorScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.apply,
        builder: (context, state) => const ApplicationFormScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.documents,
        builder: (context, state) => const DocumentUploadScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.status,
        builder: (context, state) => ApplicationStatusScreen(
          applicationId: state.uri.queryParameters['applicationId'],
        ),
      ),
    ],
  );
}

class _NavPlaceholder extends StatelessWidget {
  const _NavPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title content coming soon',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
