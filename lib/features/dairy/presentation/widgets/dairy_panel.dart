part of '../pages/milk_directory_page.dart';

class _DairyPanel extends StatelessWidget {
  const _DairyPanel({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: colorScheme.outline),
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

