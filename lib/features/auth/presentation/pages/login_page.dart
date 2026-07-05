import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finhub/app/router.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/auth/application/services/auth_service.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';
import 'package:finhub/features/auth/data/models/auth_requests.dart';

/// Login screen backed by the FinHub authentication API.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 980 : 460),
                  child: isWide
                      ? Row(
                          children: [
                            const Expanded(child: _BrandPanel()),
                            const SizedBox(width: AppSpacing.xl),
                            Expanded(
                              child: _LoginCard(content: _formContent()),
                            ),
                          ],
                        )
                      : _LoginCard(content: _formContent()),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _formContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _LogoMark(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Welcome back',
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineLarge(context),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Sign in to manage your Services.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge(
              context,
            ).copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            validator: _validatePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _isLoading ? null : _showForgotPasswordHint,
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            text: 'Login',
            icon: Icons.login_rounded,
            loading: _isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New to SmartSathi?',
                style: AppTextStyles.bodyMedium(context),
              ),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => context.push(AppRoutes.signup),
                child: const Text('Create account'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final response = await _authService.login(
        LoginRequest(
          username: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
      final body = _decodeBody(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        await AuthSession.instance.updateFromResponse(body);
        if (!mounted) return;
        if (AuthSession.instance.isAuthenticated) {
          context.go(AppRoutes.dashboard);
          return;
        }
        _showMessage('Login succeeded but no session token was returned.');
        return;
      }
      _showMessage(_messageFromBody(body) ?? 'Login failed.');
    } catch (error) {
      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic>? _decodeBody(String body) {
    if (body.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  String? _messageFromBody(Map<String, dynamic>? body) {
    final message = body?['message'] ?? body?['error'] ?? body?['title'];
    return message is String && message.isNotEmpty ? message : null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    return isValid ? null : 'Enter a valid email address';
  }

  String? _validatePassword(String? value) {
    return value == null || value.isEmpty ? 'Password is required' : null;
  }

  void _showForgotPasswordHint() {
    _showMessage('Password reset will be available soon.');
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.overlay,
            blurRadius: AppSpacing.xl,
            offset: Offset(0, AppSpacing.sm),
          ),
        ],
      ),
      child: content,
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _LogoMark(isLight: true),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'SmartSathi',
            style: AppTextStyles.displayMedium(
              context,
            ).copyWith(color: AppColors.surface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'One App. Multiple Businesses.',
            style: AppTextStyles.titleMedium(
              context,
            ).copyWith(color: AppColors.surface),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Manage loans, inventory, dairy, vehicles, plots, reports, and alerts from one secure workspace.',
            style: AppTextStyles.bodyLarge(
              context,
            ).copyWith(color: AppColors.surface),
          ),
        ],
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({this.isLight = false});

  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppSpacing.xxl,
        height: AppSpacing.xxl,
        decoration: BoxDecoration(
          color: isLight
              ? AppColors.surface.withValues(alpha: 0.16)
              : AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Image.asset('assets/images/app_logo.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
