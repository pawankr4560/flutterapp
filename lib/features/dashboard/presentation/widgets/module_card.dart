import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finhub/app/router.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dashboard/domain/entities/business_module.dart';

/// Compact dashboard service tile for a business module.
class ModuleCard extends StatelessWidget {
  const ModuleCard({super.key, required this.module, this.onTap});

  final BusinessModule module;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = module.isEnabled
        ? _colorFromHex(module.hexColor)
        : AppColors.border;
    final VoidCallback? effectiveOnTap = module.isEnabled
        ? () {
            onTap?.call();
            _handleModuleTap(context);
          }
        : null;

    return Material(
      color: module.isEnabled ? AppColors.surface : AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: InkWell(
        onTap: effectiveOnTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: Container(
          height: 156,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.overlay,
                blurRadius: AppSpacing.sm,
                offset: Offset(0, AppSpacing.xxs),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: AppSpacing.xxl,
                height: AppSpacing.xxl,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(
                  _iconFromName(module.iconName),
                  color: accentColor,
                  size: AppSpacing.lg,
                ),
              ),
              Column(
                children: [
                  Text(
                    module.title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium(context).copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    module.subtitle,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: module.isEnabled
                          ? AppColors.textSecondary
                          : AppColors.textMuted,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
      'construction' => Icons.construction_rounded,
      'directions_car' => Icons.directions_car_rounded,
      'water_drop' => Icons.water_drop_rounded,
      'home' => Icons.home_rounded,
      'agriculture' => Icons.agriculture_rounded,
      _ => Icons.apps_rounded,
    };
  }

  void _handleModuleTap(BuildContext context) {
    if (!module.isEnabled) return;

    const routableModules = {
      AppRoutes.loans,
      AppRoutes.inventory,
      AppRoutes.carBooking,
      AppRoutes.dairy,
      AppRoutes.plot,
      AppRoutes.agriculturePestiside,
    };

    if (!routableModules.contains(module.routePath)) return;
    context.push(module.routePath);
  }
}
