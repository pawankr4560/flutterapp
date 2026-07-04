import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finhub/app/router.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/loading_indicator.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';

/// Initial splash screen for the Seva Sathi application.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _resolveInitialRoute();
  }

  Future<void> _resolveInitialRoute() async {
    var isAuthenticated = false;

    try {
      await Future.wait([
        AuthSession.instance.initialize(),
        Future<void>.delayed(const Duration(milliseconds: 600)),
      ]);
      isAuthenticated = AuthSession.instance.isAuthenticated;
    } catch (_) {
      isAuthenticated = false;
    }

    if (!mounted) {
      return;
    }

    context.go(isAuthenticated ? AppRoutes.dashboard : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Seva Sathi', style: AppTextStyles.headlineLarge(context)),
                const SizedBox(height: 8),
                Text(
                  'One App. Multiple Businesses.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(context),
                ),
                const SizedBox(height: 24),
                const LoadingIndicator(
                  size: LoadingIndicatorSize.small,
                  text: 'Preparing your workspace',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


