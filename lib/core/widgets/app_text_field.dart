import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// Reusable FinHub text field with design-system decoration defaults.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.hintText,
    this.textInputAction,
    this.errorText,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;

  /// Legacy alias used by existing screens during migration.
  final String? hintText;
  final TextInputAction? textInputAction;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText && maxLines == 1,
      validator: validator,
      autovalidateMode: autovalidateMode,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      style: AppTextStyles.bodyLarge(context),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint ?? hintText,
        labelText: labelText ?? label,
        errorText: errorText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: enabled ? AppColors.surface : AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTextStyles.bodyMedium(context),
        labelStyle: AppTextStyles.bodyMedium(context),
        errorStyle: AppTextStyles.bodySmall(context).copyWith(
          color: AppColors.error,
        ),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
      borderSide: BorderSide(color: color),
    );
  }
}

