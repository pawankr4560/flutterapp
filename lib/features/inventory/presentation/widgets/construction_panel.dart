part of '../pages/inventory_directory_page.dart';

class _ConstructionPanel extends StatelessWidget {
  const _ConstructionPanel({
    required this.child,
    this.borderColor,
  });

  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: borderColor ?? colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.overlay,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

