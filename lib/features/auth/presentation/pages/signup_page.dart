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

/// Signup screen backed by the FinHub authentication API.
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _authService = AuthService();
  String _gender = 'Male';
  bool _isLoading = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text('Join FinHub', style: AppTextStyles.headlineMedium(context)),
              const SizedBox(height: AppSpacing.xs),
              Text('Create your account to manage every business.',
                  style: AppTextStyles.bodyMedium(context)),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                  controller: _firstName,
                  label: 'First Name',
                  validator: _required),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                  controller: _lastName,
                  label: 'Last Name',
                  validator: _required),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _email,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
                validator: _validateEmail,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _phone,
                label: 'Phone',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.md),
              _GenderDropdown(
                value: _gender,
                onChanged: (value) => setState(() => _gender = value),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                  controller: _address,
                  label: 'Address',
                  maxLines: 2,
                  validator: _required),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _password,
                label: 'Password',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _confirmPassword,
                label: 'Confirm Password',
                prefixIcon: Icons.lock_reset_rounded,
                obscureText: true,
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'Create Account',
                icon: Icons.person_add_alt_rounded,
                loading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final response = await _authService.signup(SignupRequest(
        email: _email.text.trim(),
        password: _password.text,
        confirmPassword: _confirmPassword.text,
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        phone: _phone.text.trim(),
        gender: _gender,
        address: _address.text.trim(),
      ));
      final body = _decodeBody(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        await AuthSession.instance.updateFromResponse(body);
        if (!mounted) return;
        if (AuthSession.instance.isAuthenticated) {
          context.go(AppRoutes.dashboard);
        } else {
          _showMessage('Account created. Please login.');
          context.go(AppRoutes.login);
        }
        return;
      }
      _showMessage(_messageFromBody(body) ?? 'Signup failed.');
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

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : 'Enter a valid email address';
  }

  String? _validatePassword(String? value) {
    return value == null || value.length < 6
        ? 'Password must be at least 6 characters'
        : null;
  }

  String? _validateConfirmPassword(String? value) {
    return value == _password.text ? null : 'Passwords do not match';
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _GenderDropdown extends StatelessWidget {
  const _GenderDropdown({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(Icons.person_outline_rounded),
        filled: true,
        fillColor: AppColors.surface,
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary),
      ),
      style: AppTextStyles.bodyLarge(context),
      items: const [
        DropdownMenuItem(value: 'Male', child: Text('Male')),
        DropdownMenuItem(value: 'Female', child: Text('Female')),
        DropdownMenuItem(value: 'Other', child: Text('Other')),
      ],
      onChanged: (value) => value == null ? null : onChanged(value),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
      borderSide: BorderSide(color: color),
    );
  }
}
