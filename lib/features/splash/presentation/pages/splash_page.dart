import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finhub/app/router.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/primary_button.dart';

/// Initial splash screen for the FinHub application.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

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
                const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primary,
                  size: 64,
                ),
                const SizedBox(height: 20),
                Text('FinHub', style: AppTextStyles.headlineLarge(context)),
                const SizedBox(height: 8),
                Text(
                  'One App. Multiple Businesses.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(context),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Continue',
                  icon: Icons.arrow_forward_rounded,
                  fullWidth: false,
                  onPressed: () => context.go(AppRoutes.onboarding),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


