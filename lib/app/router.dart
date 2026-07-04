import 'package:go_router/go_router.dart';

import 'package:finhub/features/auth/presentation/pages/login_page.dart';
import 'package:finhub/features/auth/presentation/pages/signup_page.dart';
import 'package:finhub/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:finhub/features/dairy/presentation/pages/milk_directory_page.dart';
import 'package:finhub/features/inventory/presentation/pages/inventory_directory_page.dart';
import 'package:finhub/features/loan/presentation/pages/loan_directory_page.dart';
import 'package:finhub/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:finhub/features/splash/presentation/pages/splash_page.dart';

/// Central application route paths for FinHub.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String loans = '/loans';
  static const String inventory = '/inventory';
  static const String dairy = '/dairy';
}

/// Legacy route paths still used by migrated feature screens.
class AppRoutePaths {
  const AppRoutePaths._();

  static const String login = '/login';
  static const String signup = AppRoutes.signup;
  static const String home = AppRoutes.dashboard;
  static const String loans = '/loans';
  static const String payments = '/payments';
  static const String profile = '/profile';
  static const String calculator = '/calculator';
  static const String apply = '/apply';
  static const String documents = '/documents';
  static const String uploadedDocuments = '/documents/view';
  static const String status = '/status';
}

/// GoRouter configuration for the initial FinHub navigation graph.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: AppRoutes.loans,
      name: 'loans',
      builder: (context, state) => const LoanDirectoryPage(),
    ),
    GoRoute(
      path: AppRoutes.inventory,
      name: 'inventory',
      builder: (context, state) => const InventoryDirectoryPage(),
    ),
    GoRoute(
      path: AppRoutes.dairy,
      name: 'dairy',
      builder: (context, state) => const MilkDirectoryPage(),
    ),
  ],
);
