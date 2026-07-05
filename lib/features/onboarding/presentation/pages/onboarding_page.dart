import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finhub/app/router.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/primary_button.dart';

/// Placeholder onboarding screen for introducing SmartSathi modules.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const List<String> _modules = [
    'Loan Management',
    'Car Booking',
    'Inventory',
    'Plot Management',
    'Dairy Business',
    'Reports',
    'Payments',
    'Notifications',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('SmartSathi', style: AppTextStyles.headlineLarge(context)),
            const SizedBox(height: 8),
            Text(
              'One App. Multiple Businesses.',
              style: AppTextStyles.bodyMedium(context),
            ),
            const SizedBox(height: 24),
            AppCard(
              title: 'Business modules',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _modules
                    .map(
                      (module) => Chip(
                        label: Text(module),
                        backgroundColor: AppColors.background,
                        side: const BorderSide(color: AppColors.border),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Get started',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.go(AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}
