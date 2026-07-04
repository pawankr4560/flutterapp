import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dashboard/domain/entities/business_module.dart';
import 'package:finhub/features/inventory/presentation/pages/inventory_directory_page.dart';
import 'package:finhub/features/loan/presentation/pages/loan_directory_page.dart';

/// Premium dashboard card for a single enabled business module.
class ModuleCard extends StatelessWidget {
  const ModuleCard({
    super.key,
    required this.module,
    this.onTap,
  });

  final BusinessModule module;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = _colorFromHex(module.hexColor);
    final effectiveOnTap = () {
      onTap?.call();
      _handleModuleTap(context);
    };

    return AppCard(
      onTap: effectiveOnTap,
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: AppSpacing.xxs, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: AppSpacing.xxl,
                          height: AppSpacing.xxl,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(
                              alpha: AppSpacing.xxs / AppSpacing.xl,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppRadius.large,
                            ),
                          ),
                          child: Icon(_iconFromName(module.iconName),
                              color: accentColor),
                        ),
                        const Spacer(),
                        _ArrowButton(
                          color: accentColor,
                          onTap: effectiveOnTap,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      module.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium(context),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      module.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFromHex(String value) {
    final normalized = value.replaceFirst('#', '');
    final colorValue = int.tryParse('FF$normalized', radix: 16);
    return colorValue == null ? AppColors.primary : Color(colorValue);
  }

  IconData _iconFromName(String value) {
    return switch (value) {
      'payments' => Icons.payments_rounded,
      'inventory' => Icons.inventory_2_rounded,
      'directions_car' => Icons.directions_car_rounded,
      'water_drop' => Icons.water_drop_rounded,
      'home' => Icons.home_rounded,
      _ => Icons.apps_rounded,
    };
  }

  void _handleModuleTap(BuildContext context) {
    final page = switch (module.id) {
      'loan' => const LoanDirectoryPage(),
      'inventory' => const InventoryDirectoryPage(),
      _ => null,
    };

    if (page == null) return;
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

/// Circular trailing action affordance for module cards.
class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.color, this.onTap});

  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: AppSpacing.xl,
          child: Icon(Icons.arrow_forward_rounded, color: color),
        ),
      ),
    );
  }
}
