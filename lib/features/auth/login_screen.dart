import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/auth/auth_session.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import 'auth_form_mixin.dart';
import 'auth_logo.dart';
import 'auth_requests.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.emailConfirmed,
    this.confirmationMessageId,
  });

  final bool? emailConfirmed;
  final String? confirmationMessageId;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AuthFormMixin<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  String? _usernameError;
  String? _passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    _showEmailConfirmationMessage(widget.emailConfirmed);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.emailConfirmed != widget.emailConfirmed ||
        oldWidget.confirmationMessageId != widget.confirmationMessageId) {
      _showEmailConfirmationMessage(widget.emailConfirmed);
    }
  }

  bool _isEmail(String value) => value.contains('@');

  bool _isValidEmail(String value) => _emailRegex.hasMatch(value);

  Future<void> _handleForgotPassword() async {
    final emailController = TextEditingController(
      text: _isValidEmail(_usernameController.text.trim())
          ? _usernameController.text.trim()
          : '',
    );
    String? emailError;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Reset password'),
              content: AppTextField(
                controller: emailController,
                label: 'Email',
                hintText: 'Enter your registered email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.mail_outline,
                errorText: emailError,
                onChanged: (_) {
                  if (emailError != null) {
                    setDialogState(() {
                      emailError = null;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    if (!_isValidEmail(email)) {
                      setDialogState(() {
                        emailError = 'Enter a valid email address.';
                      });
                      return;
                    }

                    Navigator.of(dialogContext).pop();
                    await _sendPasswordReset(email);
                  },
                  child: const Text('Send link'),
                ),
              ],
            );
          },
        );
      },
    );

    emailController.dispose();
  }

  Future<void> _sendPasswordReset(String email) async {
    await runAuthRequest(() async {
      try {
        final response = await _authService.forgotPassword(
          ForgotPasswordRequest(email: email),
        );
        final responseBody = _tryDecodeMap(response.body);
        final success = responseBody?['success'] == true ||
            (responseBody?['success'] != false &&
                response.statusCode >= 200 &&
                response.statusCode < 300);
        final message = responseBody?['message']?.toString();

        if (success) {
          showToast(message ?? 'Password reset link sent to your email.');
        } else {
          showToast(message ?? 'Unable to send password reset link.');
        }
      } catch (error) {
        showToast(error.toString());
      }
    });
  }

  void _showEmailConfirmationMessage(bool? emailConfirmed) {
    if (emailConfirmed == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      showToast(
        emailConfirmed
            ? 'Email confirmed successfully. Please login.'
            : 'Email confirmation failed or link expired.',
      );
    });
  }

  Future<void> _submitLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _usernameError = null;
      _passwordError = null;
    });

    var hasError = false;
    if (username.isEmpty) {
      _usernameError = 'Please enter email or phone.';
      hasError = true;
    } else if (_isEmail(username) && !_isValidEmail(username)) {
      _usernameError = 'Enter a valid email address.';
      hasError = true;
    }
    if (password.isEmpty) {
      _passwordError = 'Please enter your password.';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      final firstError = _usernameError ?? _passwordError;
      if (firstError != null) {
        showToast(firstError);
      }
      return;
    }

    await runAuthRequest(() async {
      try {
        final request = LoginRequest(username: username, password: password);
        final response = await _authService.login(request);
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>?;
        final success = responseBody?['success'] == true ||
            (responseBody?['success'] != false &&
                response.statusCode >= 200 &&
                response.statusCode < 300 &&
                _hasUserPayload(responseBody));
        final message = responseBody?['message'] as String?;

        if (success) {
          await AuthSession.instance.updateFromResponse(responseBody);
          if (!mounted) return;
          showToast(message ?? 'Login successful.');
          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return;
          context.go('/home');
        } else {
          showToast(message ?? 'Login failed. Please check your credentials.');
        }
      } catch (error) {
        showToast(error.toString());
      }
    });
  }

  bool _hasUserPayload(Map<String, dynamic>? responseBody) {
    if (responseBody == null) {
      return false;
    }

    final data = responseBody['data'];
    return responseBody['user'] is Map<String, dynamic> ||
        (data is Map<String, dynamic> && data['user'] is Map<String, dynamic>);
  }

  Map<String, dynamic>? _tryDecodeMap(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

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
                  const AuthLogo(icon: Icons.account_balance_wallet_outlined),
                  const SizedBox(height: 28),
                  Text(
                    'Welcome back',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Sign in to manage your loans and payments.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppTextField(
                    controller: _usernameController,
                    label: 'Email or phone',
                    hintText: 'Enter your email or phone',
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.person_outline,
                    enabled: !isLoading,
                    errorText: _usernameError,
                    onChanged: (_) {
                      if (_usernameError != null) {
                        setState(() {
                          _usernameError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: 'Enter your password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.lock_outline,
                    enabled: !isLoading,
                    errorText: _passwordError,
                    onChanged: (_) {
                      if (_passwordError != null) {
                        setState(() {
                          _passwordError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _handleForgotPassword,
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: isLoading ? 'Logging in...' : 'Log in',
                    onPressed: isLoading ? null : _submitLogin,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text(
                          "Don't have an account?",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      TextButton(
                        onPressed: isLoading ? null : () => context.push('/signup'),
                        child: const Text('Create account'),
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

