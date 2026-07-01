import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import 'auth_form_mixin.dart';
import 'auth_logo.dart';
import 'auth_requests.dart';
import 'auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with AuthFormMixin<SignupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _addressError;
  String? _passwordError;
  String? _confirmPasswordError;
  String _gender = 'Male';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

  bool _isValidEmail(String value) => _emailRegex.hasMatch(value);

  bool _isValidPhone(String value) => _phoneRegex.hasMatch(value);

  Future<void> _submitSignup() async {
    final name = _nameController.text.trim();
    final phoneValue = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _nameError = null;
      _phoneError = null;
      _emailError = null;
      _addressError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    var hasError = false;

    if (name.isEmpty) {
      _nameError = 'Name is required';
      hasError = true;
    }
    if (phoneValue.isEmpty) {
      _phoneError = 'Phone number is required';
      hasError = true;
    } else if (!_isValidPhone(phoneValue)) {
      _phoneError = 'Enter a valid phone number';
      hasError = true;
    }
    if (email.isEmpty) {
      _emailError = 'Email is required';
      hasError = true;
    } else if (!_isValidEmail(email)) {
      _emailError = 'Enter a valid email address';
      hasError = true;
    }
    if (address.isEmpty) {
      _addressError = 'Address is required';
      hasError = true;
    }
    if (password.isEmpty) {
      _passwordError = 'Password is required';
      hasError = true;
    }
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Confirm password is required';
      hasError = true;
    }
    if (password.isNotEmpty && confirmPassword.isNotEmpty && password != confirmPassword) {
      _confirmPasswordError = 'Passwords do not match.';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      final firstError = _nameError ?? _phoneError ?? _emailError ?? _addressError ?? _passwordError ?? _confirmPasswordError;
      if (firstError != null) {
        showToast(firstError);
      }
      return;
    }

    await runAuthRequest(() async {
      final splitName = name.split(RegExp(r'\s+'));
      final firstName = splitName.isNotEmpty ? splitName.first : name;
      final lastName = splitName.length > 1 ? splitName.sublist(1).join(' ') : '';

      final request = SignupRequest(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
        phone: phoneValue,
        gender: _gender,
        address: address,
      );

      final response = await _authService.signup(request);
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>?;
      final success = responseBody?['success'] == true;
      final message = responseBody?['message'] as String?;

      if (success) {
        if (!mounted) return;
        showToast(message ?? 'Signup successful. Please log in.');
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        context.push('/login');
      } else {
        showToast(message ?? 'Signup failed (${response.statusCode}).');
      }
    });
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
                  const AuthLogo(icon: Icons.person_add_alt_1_outlined),
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
                  AppTextField(
                    controller: _nameController,
                    label: 'Name',
                    hintText: 'Enter your full name',
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.person_outline,
                    enabled: !isLoading,
                    errorText: _nameError,
                    onChanged: (_) {
                      if (_nameError != null) {
                        setState(() {
                          _nameError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _phoneController,
                    label: 'Phone number',
                    hintText: 'Enter your phone number',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.phone_outlined,
                    enabled: !isLoading,
                    errorText: _phoneError,
                    onChanged: (_) {
                      if (_phoneError != null) {
                        setState(() {
                          _phoneError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _emailController,
                    label: 'Email',
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.mail_outline,
                    enabled: !isLoading,
                    errorText: _emailError,
                    onChanged: (_) {
                      if (_emailError != null) {
                        setState(() {
                          _emailError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _addressController,
                    label: 'Address',
                    hintText: 'Enter your address',
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.home_outlined,
                    enabled: !isLoading,
                    errorText: _addressError,
                    onChanged: (_) {
                      if (_addressError != null) {
                        setState(() {
                          _addressError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.accent, width: 1.4),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _gender,
                        isExpanded: true,
                        onChanged: isLoading
                            ? null
                            : (value) {
                                if (value == null) return;
                                setState(() {
                                  _gender = value;
                                });
                              },
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(value: 'Female', child: Text('Female')),
                          DropdownMenuItem(value: 'Other', child: Text('Other')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: 'Create a password',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
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
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm password',
                    hintText: 'Re-enter your password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.verified_user_outlined,
                    enabled: !isLoading,
                    errorText: _confirmPasswordError,
                    onChanged: (_) {
                      if (_confirmPasswordError != null) {
                        setState(() {
                          _confirmPasswordError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: isLoading ? 'Creating account...' : 'Create account',
                    onPressed: isLoading ? null : _submitSignup,
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
                        onPressed: isLoading ? null : () => context.push('/login'),
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

