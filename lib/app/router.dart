import 'package:go_router/go_router.dart';

import 'package:finhub/features/agriculture/presentation/pages/agriculture_directory_page.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';
import 'package:finhub/features/auth/presentation/pages/login_page.dart';
import 'package:finhub/features/auth/presentation/pages/signup_page.dart';
import 'package:finhub/features/car_booking/presentation/pages/car_booking_directory_page.dart';
import 'package:finhub/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:finhub/features/dairy/presentation/pages/milk_directory_page.dart';
import 'package:finhub/features/inventory/presentation/pages/inventory_directory_page.dart';
import 'package:finhub/features/loan/presentation/pages/application_form_screen.dart';
import 'package:finhub/features/loan/presentation/pages/application_status_screen.dart';
import 'package:finhub/features/loan/presentation/pages/document_upload_screen.dart';
import 'package:finhub/features/loan/presentation/pages/emi_calculator_screen.dart';
import 'package:finhub/features/loan/presentation/pages/loan_directory_page.dart';
import 'package:finhub/features/loan/presentation/pages/uploaded_documents_screen.dart';
import 'package:finhub/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:finhub/features/payments/presentation/pages/payments_screen.dart';
import 'package:finhub/features/plot/presentation/pages/plot_directory_page.dart';
import 'package:finhub/features/profile/presentation/pages/profile_screen.dart';
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
  static const String carBooking = '/car-booking';
  static const String dairy = '/dairy';
  static const String plot = '/plot';
  static const String agriculturePestiside = '/agriculture-pestiside';
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
  refreshListenable: AuthSession.instance,
  redirect: (context, state) {
    const publicRoutes = {
      AppRoutes.splash,
      AppRoutes.onboarding,
      AppRoutes.login,
      AppRoutes.signup,
    };
    final matchedLocation = state.matchedLocation;

    if (matchedLocation == AppRoutes.splash) {
      return null;
    }

    if (!AuthSession.instance.isAuthenticated &&
        !publicRoutes.contains(matchedLocation)) {
      return AppRoutes.login;
    }

    if (AuthSession.instance.isAuthenticated &&
        (matchedLocation == AppRoutes.login ||
            matchedLocation == AppRoutes.signup)) {
      return AppRoutes.dashboard;
    }

    return null;
  },
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
      path: AppRoutes.carBooking,
      name: 'carBooking',
      builder: (context, state) => const CarBookingDirectoryPage(),
    ),
    GoRoute(
      path: AppRoutes.dairy,
      name: 'dairy',
      builder: (context, state) => const MilkDirectoryPage(),
    ),
    GoRoute(
      path: AppRoutes.plot,
      name: 'plot',
      builder: (context, state) => const PlotDirectoryPage(),
    ),
    GoRoute(
      path: AppRoutes.agriculturePestiside,
      name: 'agriculturePestiside',
      builder: (context, state) => const AgricultureDirectoryPage(),
    ),
    GoRoute(
      path: AppRoutes.payments,
      name: 'payments',
      builder: (context, state) => const PaymentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.calculator,
      name: 'calculator',
      builder: (context, state) => const EmiCalculatorScreen(),
    ),
    GoRoute(
      path: AppRoutes.apply,
      name: 'apply',
      builder: (context, state) => const ApplicationFormScreen(),
    ),
    GoRoute(
      path: AppRoutes.documents,
      name: 'documents',
      builder: (context, state) => DocumentUploadScreen(
        applicationId: state.uri.queryParameters['applicationId'],
      ),
    ),
    GoRoute(
      path: AppRoutes.uploadedDocuments,
      name: 'uploadedDocuments',
      builder: (context, state) => UploadedDocumentsScreen(
        applicationId: state.uri.queryParameters['applicationId'],
      ),
    ),
    GoRoute(
      path: AppRoutes.status,
      name: 'status',
      builder: (context, state) => ApplicationStatusScreen(
        applicationId: state.uri.queryParameters['applicationId'],
      ),
    ),
  ],
);

