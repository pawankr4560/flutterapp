import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_session.dart';
import '../../features/application/application_form_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/calculator/emi_calculator_screen.dart';
import '../../features/documents/document_upload_screen.dart';
import '../../features/home/dashboard_screen.dart';
import '../../features/home/loans_screen.dart';
import '../../features/home/payments_screen.dart';
import '../../features/home/profile_screen.dart';
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
    refreshListenable: AuthSession.instance,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = AuthSession.instance.isAuthenticated;
      final loggingIn = state.uri.path == AppRoutePaths.login;
      final signingUp = state.uri.path == AppRoutePaths.signup;

      if (!isAuthenticated && !loggingIn && !signingUp) {
        return AppRoutePaths.login;
      }

      if (isAuthenticated && (loggingIn || signingUp)) {
        return AppRoutePaths.home;
      }

      return null;
    },
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
            builder: (context, state) => const LoansScreen(),
          ),
          GoRoute(
            path: AppRoutePaths.payments,
            builder: (context, state) => const PaymentsScreen(),
          ),
          GoRoute(
            path: AppRoutePaths.profile,
            builder: (context, state) => const ProfileScreen(),
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

