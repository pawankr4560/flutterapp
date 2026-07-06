import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/app/theme_controller.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';

/// App-style dashboard header with greeting and wallet summary.
class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = AuthSession.instance.userName.trim();
    final firstName = userName.isEmpty ? 'Ravi' : userName.split(' ').first;
    final themeMode = ref.watch(themeModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $firstName',
                    style: AppTextStyles.titleMedium(context),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Good Morning',
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            _ThemeCycleButton(
              themeMode: themeMode,
              onTap: () {
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(_nextThemeMode(themeMode));
              },
            ),
            const SizedBox(width: AppSpacing.xs),
            const _NotificationButton(),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: const [
              BoxShadow(
                color: AppColors.overlay,
                blurRadius: AppSpacing.lg,
                offset: Offset(0, AppSpacing.xs),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance',
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Rs. 25,000',
                      style: AppTextStyles.headlineMedium(context).copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _ViewWalletButton(onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const _WalletIllustration(),
            ],
          ),
        ),
      ],
    );
  }

  ThemeMode _nextThemeMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => ThemeMode.system,
      ThemeMode.system => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
    };
  }
}

class _ThemeCycleButton extends StatelessWidget {
  const _ThemeCycleButton({
    required this.themeMode,
    required this.onTap,
  });

  final ThemeMode themeMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Theme: ${_label(themeMode)}',
      child: _HeaderIconMaterial(
        icon: _icon(themeMode),
        onTap: onTap,
      ),
    );
  }

  IconData _icon(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => Icons.light_mode_outlined,
      ThemeMode.system => Icons.phone_android_rounded,
      ThemeMode.dark => Icons.dark_mode_outlined,
    };
  }

  String _label(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'Light',
      ThemeMode.system => 'System',
      ThemeMode.dark => 'Dark',
    };
  }
}

class _HeaderIconMaterial extends StatelessWidget {
  const _HeaderIconMaterial({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: AppSpacing.xxl,
          child: Icon(icon, color: colorScheme.onSurface),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _HeaderIconMaterial(
          icon: Icons.notifications_none_rounded,
          onTap: () {},
        ),
        Positioned(
          right: AppSpacing.sm,
          top: AppSpacing.sm,
          child: Container(
            width: AppSpacing.xs,
            height: AppSpacing.xs,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _ViewWalletButton extends StatelessWidget {
  const _ViewWalletButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View Wallet',
                style: AppTextStyles.bodySmall(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primary,
                size: AppSpacing.md,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletIllustration extends StatelessWidget {
  const _WalletIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            top: AppSpacing.sm,
            child: Container(
              width: 58,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.surface,
                size: AppSpacing.xl,
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.warning,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.currency_rupee_rounded,
                color: AppColors.surface,
                size: AppSpacing.lg,
              ),
            ),
          ),
          Positioned(
            right: AppSpacing.md,
            top: 0,
            child: Transform.rotate(
              angle: -0.35,
              child: const Icon(
                Icons.credit_card_rounded,
                color: AppColors.surface,
                size: AppSpacing.xl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
