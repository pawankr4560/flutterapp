import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// Secondary FinHub action button backed by an outlined Material 3 button.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    this.icon,
    this.loading = false,
    this.onPressed,
    this.enabled = true,
    this.fullWidth = true,
  });

  final String text;
  final IconData? icon;
  final bool loading;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = enabled && !loading ? onPressed : null;
    final textStyle = AppTextStyles.labelLarge(context);
    final child = loading
        ? const SizedBox.square(
            dimension: AppSpacing.lg,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSpacing.md),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: AppSpacing.xxl,
      child: OutlinedButton(
        onPressed: effectiveOnPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textSecondary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          textStyle: textStyle,
        ),
        child: child,
      ),
    );
  }
}
