import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SignupLogo(),
                  const SizedBox(height: 28),
                  Text(
                    'Create account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Start tracking loan applications and repayments.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const AppTextField(
                    label: 'Name',
                    hintText: 'Enter your full name',
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AppTextField(
                    label: 'Phone number',
                    hintText: 'Enter your phone number',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AppTextField(
                    label: 'Email',
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.mail_outline,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AppTextField(
                    label: 'Password',
                    hintText: 'Create a password',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AppTextField(
                    label: 'Confirm password',
                    hintText: 'Re-enter your password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.verified_user_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Create account',
                    onPressed: () => context.go('/home'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text(
                          'Already have an account?',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Log in'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupLogo extends StatelessWidget {
  const _SignupLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.22),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add_alt_1_outlined,
            color: Colors.white,
            size: 38,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Loan Tracker',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
