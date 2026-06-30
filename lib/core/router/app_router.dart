import 'package:go_router/go_router.dart';

import '../../features/application/application_form_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/calculator/emi_calculator_screen.dart';
import '../../features/documents/document_upload_screen.dart';
import '../../features/home/dashboard_screen.dart';
import '../../features/status/application_status_screen.dart';

class AppRoutePaths {
  const AppRoutePaths._();

  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
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
      GoRoute(
        path: AppRoutePaths.home,
        builder: (context, state) => const DashboardScreen(),
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
        builder: (context, state) => const ApplicationStatusScreen(),
      ),
    ],
  );
}
