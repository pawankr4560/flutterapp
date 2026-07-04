import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'primary_button.dart';

/// Legacy button API backed by the FinHub primary button styles.
enum AppButtonVariant { primary, secondary }

/// Compatibility wrapper for older screens while new code uses [PrimaryButton].
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.primary) {
      return PrimaryButton(text: label, icon: icon, onPressed: onPressed);
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 20),
        label: Text(label, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}


