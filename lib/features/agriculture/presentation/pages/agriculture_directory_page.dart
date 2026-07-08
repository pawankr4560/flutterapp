import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_form_controls.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/error_view.dart';
import 'package:finhub/core/widgets/loading_indicator.dart';
import 'package:finhub/features/agriculture/application/services/agriculture_service.dart';
import 'package:finhub/features/agriculture/domain/entities/agriculture_stock_item.dart';
import 'package:finhub/features/agriculture/domain/entities/field_record.dart';
import 'package:finhub/features/agriculture/presentation/pages/log_spray_page.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';

/// Field and pesticide management dashboard for agriculture businesses.
class AgricultureDirectoryPage extends StatefulWidget {
  const AgricultureDirectoryPage({super.key});

  @override
  State<AgricultureDirectoryPage> createState() => _AgricultureDirectoryPageState();
}

class _AgricultureDirectoryPageState extends State<AgricultureDirectoryPage> {
  final _service = AgricultureService();
  String _selectedStatus = 'All';
  var _loading = true;
  String? _errorMessage;
  List<FieldRecord> _fields = [];
  List<AgricultureStockItem> _stockItems = [];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Agriculture')),
        body: const SafeArea(
          child: LoadingIndicator(text: 'Loading agriculture records...'),
        ),
      );
    }

    final errorMessage = _errorMessage;
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Agriculture')),
        body: SafeArea(
          child: ErrorView(
            title: 'Unable to load agriculture data',
            message: errorMessage,
            retryButtonText: 'Retry',
            onRetry: _loadDashboard,
          ),
        ),
      );
    }

    final fields = _selectedStatus == 'All'
        ? _fields
        : _fields.where((field) => field.status == _selectedStatus).toList();

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
            if (_stockItems.isEmpty)
              const _EmptyStockItems()
            else
              for (final item in _stockItems) ...[
                _StockItemCard(item: item),
                const SizedBox(height: AppSpacing.sm),
              ],
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showAddStockSheet,
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
    Navigator.of(context)
        .push<bool>(
          MaterialPageRoute<bool>(
            builder: (_) => LogSprayPage(fields: _fields),
          ),
        )
        .then((logged) {
          if (logged == true) _loadDashboard();
        });
  }

  Future<void> _showAddStockSheet() async {
    final entry = await showModalBottomSheet<_StockFormValue>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _StockEntrySheet(),
    );
    if (entry == null) return;

    try {
      final item = await _service.createStockItem(
        bearerToken: AuthSession.instance.bearerToken,
        name: entry.name,
        quantity: entry.quantity,
        unit: entry.unit,
        status: entry.status,
      );
      if (!mounted) return;
      setState(() => _stockItems.insert(0, item));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock entry added successfully')),
      );
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final dashboard = await _service.fetchDashboard(
        AuthSession.instance.bearerToken,
      );
      if (!mounted) return;
      setState(() {
        _fields = dashboard.fields;
        _stockItems = dashboard.stockItems;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = _friendlyError(error);
      });
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_friendlyError(error))),
    );
  }

  String _friendlyError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    return message.isEmpty ? 'Something went wrong. Please try again.' : message;
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

class _EmptyStockItems extends StatelessWidget {
  const _EmptyStockItems();

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
        'No stock entries found.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyLarge(context).copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _StockEntrySheet extends StatefulWidget {
  const _StockEntrySheet();

  @override
  State<_StockEntrySheet> createState() => _StockEntrySheetState();
}

class _StockEntrySheetState extends State<_StockEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  String _unit = 'kg';
  String _status = 'Sufficient';

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add stock entry', style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: AppSpacing.md),
            AppFormTextField(controller: _nameController, label: 'Name'),
            AppFormTextField(
              controller: _quantityController,
              label: 'Quantity',
              keyboardType: TextInputType.number,
              validatePositiveNumber: true,
            ),
            AppDropdownField<String>(
              label: 'Unit',
              value: _unit,
              items: const ['kg', 'litres', 'ml', 'units'],
              onChanged: (value) => setState(() => _unit = value),
            ),
            AppDropdownField<String>(
              label: 'Status',
              value: _status,
              items: const ['Sufficient', 'Low stock', 'Out of stock'],
              onChanged: (value) => setState(() => _status = value),
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton(
              onPressed: _submit,
              child: const Text('Save stock entry'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _StockFormValue(
        name: _nameController.text.trim(),
        quantity: double.parse(_quantityController.text.trim()),
        unit: _unit,
        status: _status,
      ),
    );
  }
}

class _StockFormValue {
  const _StockFormValue({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.status,
  });

  final String name;
  final double quantity;
  final String unit;
  final String status;
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
