import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_form_controls.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/error_view.dart';
import 'package:finhub/core/widgets/loading_indicator.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/agriculture/application/services/agriculture_service.dart';
import 'package:finhub/features/agriculture/domain/entities/field_record.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';

/// Form for logging pesticide or fertilizer spray application.
class LogSprayPage extends StatefulWidget {
  const LogSprayPage({super.key, required this.fields});

  final List<FieldRecord> fields;

  @override
  State<LogSprayPage> createState() => _LogSprayPageState();
}

class _LogSprayPageState extends State<LogSprayPage> {
  final _service = AgricultureService();
  String? _fieldId;
  String? _productId;
  DateTime? _applicationDate;
  var _loading = true;
  var _saving = false;
  String? _errorMessage;
  List<SprayProduct> _products = [];

  @override
  void initState() {
    super.initState();
    _fieldId = widget.fields.isEmpty ? null : widget.fields.first.id;
    _loadSprayProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Log spray application')),
        body: const SafeArea(
          child: LoadingIndicator(text: 'Loading spray products...'),
        ),
      );
    }

    final errorMessage = _errorMessage;
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Log spray application')),
        body: SafeArea(
          child: ErrorView(
            title: 'Unable to load spray products',
            message: errorMessage,
            retryButtonText: 'Retry',
            onRetry: _loadSprayProducts,
          ),
        ),
      );
    }

    if (widget.fields.isEmpty || _products.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Log spray application')),
        body: const SafeArea(
          child: Center(child: Text('No fields or spray products available.')),
        ),
      );
    }

    final fields = widget.fields;
    final selectedField = fields.firstWhere(
      (field) => field.id == _fieldId,
      orElse: () => fields.first,
    );
    final selectedProduct = _products.firstWhere(
      (product) => product.id == _productId,
      orElse: () => _products.first,
    );
    final dosage = selectedField.areaAcres * selectedProduct.dosagePerAcre;

    return Scaffold(
      appBar: AppBar(title: const Text('Log spray application')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            AppFieldLabel(label: 'Field'),
            const SizedBox(height: AppSpacing.xs),
            AppDropdownField<String>(
              label: null,
              value: _fieldId!,
              items: fields.map((field) => field.id).toList(),
              itemLabel: (id) {
                final field = fields.firstWhere((field) => field.id == id);
                return '${field.name} - ${field.areaAcres.toStringAsFixed(1)} acres';
              },
              decoration: AppFormDecorations.filled(),
              style: AppTextStyles.bodyLarge(context),
              bottomSpacing: 0,
              onChanged: (value) => setState(() => _fieldId = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppFieldLabel(label: 'Pesticide or fertilizer'),
            const SizedBox(height: AppSpacing.xs),
            AppDropdownField<String>(
              label: null,
              value: selectedProduct.id,
              items: _products.map((product) => product.id).toList(),
              itemLabel: (id) {
                final product = _products.firstWhere((item) => item.id == id);
                return product.displayLabel;
              },
              decoration: AppFormDecorations.filled(),
              style: AppTextStyles.bodyLarge(context),
              bottomSpacing: 0,
              onChanged: (value) => setState(() => _productId = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppFieldLabel(label: 'Application date'),
            const SizedBox(height: AppSpacing.xs),
            AppDateDisplayTile(
              date: _applicationDate,
              onTap: _pickDate,
              formatDate: _formatDate,
            ),
            const SizedBox(height: AppSpacing.lg),
            _DosageCard(
              field: selectedField,
              product: selectedProduct,
              dosage: dosage,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: 'Save spray log',
              icon: Icons.check_rounded,
              loading: _saving,
              onPressed: _saveLog,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _applicationDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() => _applicationDate = picked);
    }
  }

  Future<void> _saveLog() async {
    final date = _applicationDate;
    if (date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select application date.')),
      );
      return;
    }

    final field = widget.fields.firstWhere((field) => field.id == _fieldId);
    final product = _products.firstWhere((product) => product.id == _productId);
    setState(() => _saving = true);

    try {
      await _service.logSpray(
        bearerToken: AuthSession.instance.bearerToken,
        field: field,
        product: product,
        applicationDate: date,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_friendlyError(error))),
      );
    }
  }

  Future<void> _loadSprayProducts() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final products = await _service.fetchSprayProducts(
        AuthSession.instance.bearerToken,
      );
      if (!mounted) return;
      setState(() {
        _products = products;
        _productId = products.isEmpty ? null : products.first.id;
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

  String _friendlyError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    return message.isEmpty ? 'Something went wrong. Please try again.' : message;
  }
}

class _DosageCard extends StatelessWidget {
  const _DosageCard({
    required this.field,
    required this.product,
    required this.dosage,
  });

  final FieldRecord field;
  final SprayProduct product;
  final double dosage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dosage calculation',
                  style: AppTextStyles.titleMedium(context).copyWith(
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${field.areaAcres.toStringAsFixed(1)} acres x ${product.displayLabel}',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Estimated dosage: ${dosage.toStringAsFixed(0)} ${product.dosageUnit}',
                  style: AppTextStyles.titleMedium(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day-$month-${date.year}';
}

