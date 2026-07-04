import 'package:flutter/material.dart';

/// Reusable FinHub text field with design-system decoration defaults.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.enabled = true,
    this.hintText,
    this.textInputAction,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool enabled;

  /// Legacy alias used by existing screens during migration.
  final String? hintText;
  final TextInputAction? textInputAction;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      readOnly: readOnly,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint ?? hintText,
        labelText: label,
        errorText: errorText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: suffixIcon,
      ),
    );

    return field;
  }
}


