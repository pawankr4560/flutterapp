import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finhub/app/router.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:finhub/core/widgets/primary_button.dart';

/// Placeholder login screen for the FinHub authentication flow.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome back',
                    style: AppTextStyles.headlineMedium(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to manage your businesses.',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                  const SizedBox(height: 24),
                  const AppTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    prefixIcon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const AppTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Login',
                    icon: Icons.login_rounded,
                    onPressed: () => context.go(AppRoutes.dashboard),
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


