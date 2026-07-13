part of '../pages/inventory_directory_page.dart';

class ConstructionStatusBadge extends StatelessWidget {
  const ConstructionStatusBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = switch (_statusKey(label)) {
      'pending' => AppColors.warning,
      'confirmed' || 'processing' || 'loading' => AppColors.textSecondary,
      'placed' || 'shipped' || 'outfordelivery' => AppColors.accentDark,
      'delivered' || 'available' => AppColors.success,
      'cancelled' => AppColors.error,
      _ => AppColors.accentDark,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        _statusLabel(label),
        style: AppTextStyles.bodySmall(
          context,
        ).copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

String _statusKey(String value) {
  return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
}

String _statusLabel(String value) {
  final normalized = value
      .replaceAll('_', ' ')
      .replaceAll('-', ' ')
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)} ${match.group(2)}',
      )
      .trim();
  if (normalized.isEmpty) return 'Unknown';
  return normalized
      .split(RegExp(r'\s+'))
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join(' ');
}
