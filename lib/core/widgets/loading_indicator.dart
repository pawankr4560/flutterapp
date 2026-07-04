import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_spacing.dart';

/// FinHub loading indicator with responsive size variants.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.size = LoadingIndicatorSize.medium,
    this.text,
  });

  final LoadingIndicatorSize size;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final indicatorSize = switch (size) {
      LoadingIndicatorSize.small => AppSpacing.md,
      LoadingIndicatorSize.medium => AppSpacing.lg,
      LoadingIndicatorSize.large => AppSpacing.xl,
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: indicatorSize,
            child: const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: AppSpacing.xxs,
            ),
          ),
          if (text != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              text!,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(context),
            ),
          ],
        ],
      ),
    );
  }
}

/// Supported loading indicator sizes.
enum LoadingIndicatorSize { small, medium, large }
