import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dashboard/domain/entities/business_module.dart';
import 'package:finhub/features/dashboard/presentation/widgets/module_card.dart';

/// Responsive quick modules grid for business modules.
class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({
    super.key,
    required this.modules,
    this.onModuleTap,
  });

  final List<BusinessModule> modules;
  final ValueChanged<BusinessModule>? onModuleTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Our Services', style: AppTextStyles.titleMedium(context)),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= AppSpacing.xxl * 12;
            final columns = isTablet ? 6 : 3;
            final spacing = AppSpacing.md;
            final itemWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final module in modules)
                  SizedBox(
                    width: itemWidth,
                    child: ModuleCard(
                      module: module,
                      onTap: () => onModuleTap?.call(module),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
