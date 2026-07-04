import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/agriculture/domain/entities/agriculture_stock_item.dart';
import 'package:finhub/features/agriculture/domain/entities/field_record.dart';
import 'package:finhub/features/agriculture/presentation/pages/log_spray_page.dart';
import 'package:finhub/features/agriculture/presentation/providers/agriculture_provider.dart';

/// Field and pesticide management dashboard for agriculture businesses.
class AgricultureDirectoryPage extends ConsumerStatefulWidget {
  const AgricultureDirectoryPage({super.key});

  @override
  ConsumerState<AgricultureDirectoryPage> createState() =>
      _AgricultureDirectoryPageState();
}

class _AgricultureDirectoryPageState
    extends ConsumerState<AgricultureDirectoryPage> {
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(agricultureProvider);
    final fields = _selectedStatus == 'All'
        ? state.fields
        : state.fields.where((field) => field.status == _selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Agriculture')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Field records', style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: AppSpacing.md),
            _StatusFilters(
              selectedStatus: _selectedStatus,
              onChanged: (status) => setState(() => _selectedStatus = status),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (fields.isEmpty)
              _EmptyFields(status: _selectedStatus)
            else
              for (final field in fields) ...[
                _FieldRecordCard(field: field),
                const SizedBox(height: AppSpacing.sm),
              ],
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openLogSpray,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Log spray application'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Pesticide and fertilizer stock',
              style: AppTextStyles.titleLarge(context),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final item in state.stockItems) ...[
              _StockItemCard(item: item),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showStockEntryHint,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add stock entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLogSpray() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const LogSprayPage()),
    );
  }

  void _showStockEntryHint() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stock entry form will be added next.')),
    );
  }
}

class _StatusFilters extends StatelessWidget {
  const _StatusFilters({required this.selectedStatus, required this.onChanged});

  final String selectedStatus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final status in const ['All', 'Healthy', 'Needs attention'])
          ChoiceChip(
            label: Text(status),
            selected: selectedStatus == status,
            onSelected: (_) => onChanged(status),
            labelStyle: AppTextStyles.bodyLarge(context).copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            selectedColor: AppColors.primary.withValues(alpha: 0.12),
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              side: const BorderSide(color: AppColors.border),
            ),
          ),
      ],
    );
  }
}

class _FieldRecordCard extends StatelessWidget {
  const _FieldRecordCard({required this.field});

  final FieldRecord field;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        field.needsAttention ? AppColors.error : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.name, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${field.crop} - ${field.areaAcres.toStringAsFixed(1)} acres',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Last sprayed ${_formatDate(field.lastSprayedDate)}',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _StatusBadge(label: field.status, color: statusColor),
        ],
      ),
    );
  }
}

class _StockItemCard extends StatelessWidget {
  const _StockItemCard({required this.item});

  final AgricultureStockItem item;

  @override
  Widget build(BuildContext context) {
    final color = switch (item.status) {
      'Sufficient' => AppColors.success,
      'Low stock' => AppColors.warning,
      'Out of stock' => AppColors.error,
      _ => AppColors.primary,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  item.quantityLabel,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _StatusBadge(label: item.status, color: color),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall(context).copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyFields extends StatelessWidget {
  const _EmptyFields({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'No $status field records found.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyLarge(context).copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day} ${_monthName(date.month)} ${date.year}';
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
