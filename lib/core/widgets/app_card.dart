import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// Reusable card container that follows the FinHub design system.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.onTap,
    this.borderRadius = AppRadius.xl,
    this.backgroundColor,
    this.shadow = false,
  });

  final String? title;
  final String? subtitle;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? backgroundColor;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final colorScheme = Theme.of(context).colorScheme;
    final content = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(title!, style: AppTextStyles.titleMedium(context)),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(subtitle!, style: AppTextStyles.bodyMedium(context)),
            ],
            const SizedBox(height: AppSpacing.sm),
          ],
          child,
        ],
      ),
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: shadow
            ? const [
                BoxShadow(
                  color: AppColors.overlay,
                  blurRadius: AppSpacing.lg,
                  offset: Offset(AppSpacing.xxs, AppSpacing.sm),
                ),
              ]
            : null,
      ),
      child: Material(
        color: backgroundColor ?? colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: colorScheme.outline),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: content,
        ),
      ),
    );
  }
}

