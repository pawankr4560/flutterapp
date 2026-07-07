import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.bodyLarge(context).copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class AppFormTextField extends StatelessWidget {
  const AppFormTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.minLines,
    this.maxLines,
    this.required = true,
    this.requiredMessage = 'Required',
    this.validatePositiveNumber = false,
    this.positiveNumberMessage = 'Enter a valid value',
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final bool required;
  final String requiredMessage;
  final bool validatePositiveNumber;
  final String positiveNumberMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(labelText: label),
        validator: validator ?? _defaultValidator,
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (required && (value ?? '').trim().isEmpty) return requiredMessage;
    if (validatePositiveNumber &&
        (double.tryParse((value ?? '').trim()) ?? 0) <= 0) {
      return positiveNumberMessage;
    }
    return null;
  }
}

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabel,
    this.decoration,
    this.style,
    this.hint,
    this.bottomSpacing = AppSpacing.md,
    this.fallbackToFirst = false,
  });

  final String? label;
  final T? value;
  final List<T> items;
  final ValueChanged<T> onChanged;
  final String Function(T item)? itemLabel;
  final InputDecoration? decoration;
  final TextStyle? style;
  final Widget? hint;
  final double bottomSpacing;
  final bool fallbackToFirst;

  @override
  Widget build(BuildContext context) {
    final safeValue = items.contains(value)
        ? value
        : (fallbackToFirst && items.isNotEmpty ? items.first : null);
    final field = DropdownButtonFormField<T>(
      initialValue: safeValue,
      decoration: decoration ?? InputDecoration(labelText: label),
      style: style,
      hint: hint,
      items: [
        for (final item in items)
          DropdownMenuItem<T>(
            value: item,
            child: Text(itemLabel == null ? '$item' : itemLabel!(item)),
          ),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );

    if (bottomSpacing == 0) return field;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: field,
    );
  }
}

class AppDatePickerField extends StatelessWidget {
  const AppDatePickerField({
    super.key,
    required this.date,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    required this.formatDate,
    this.label = 'Date',
    this.icon = Icons.calendar_today_rounded,
    this.bottomSpacing = AppSpacing.md,
  });

  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String Function(DateTime date) formatDate;
  final String label;
  final IconData icon;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    final tile = InkWell(
      borderRadius: BorderRadius.circular(AppRadius.large),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: firstDate,
          lastDate: lastDate,
          initialDate: date,
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        child: Text(formatDate(date)),
      ),
    );

    if (bottomSpacing == 0) return tile;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: tile,
    );
  }
}

class AppDateDisplayTile extends StatelessWidget {
  const AppDateDisplayTile({
    super.key,
    required this.date,
    required this.onTap,
    required this.formatDate,
    this.placeholder = 'dd-mm-yyyy',
    this.decoration,
    this.bottomSpacing = 0,
  });

  final DateTime? date;
  final VoidCallback onTap;
  final String Function(DateTime date) formatDate;
  final String placeholder;
  final InputDecoration? decoration;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    final tile = InkWell(
      borderRadius: BorderRadius.circular(AppRadius.large),
      onTap: onTap,
      child: InputDecorator(
        decoration: decoration ??
            AppFormDecorations.filled(
              suffixIcon: const Icon(Icons.calendar_month_rounded),
            ),
        child: Text(
          date == null ? placeholder : formatDate(date!),
          style: AppTextStyles.bodyLarge(context).copyWith(
            color: date == null
                ? AppColors.textSecondary
                : AppColors.textPrimary,
          ),
        ),
      ),
    );

    if (bottomSpacing == 0) return tile;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: tile,
    );
  }
}

class AppSearchAndFilter extends StatelessWidget {
  const AppSearchAndFilter({
    super.key,
    required this.hint,
    required this.onChanged,
    this.showFilter = true,
    this.onFilterPressed,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final bool showFilter;
  final VoidCallback? onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
        ),
        if (showFilter) ...[
          const SizedBox(width: AppSpacing.sm),
          IconButton.filledTonal(
            onPressed: onFilterPressed ?? () {},
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ],
    );
  }
}

class AppFormDecorations {
  const AppFormDecorations._();

  static InputDecoration filled({Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surface,
      suffixIcon: suffixIcon,
      border: _border(AppColors.border),
      enabledBorder: _border(AppColors.border),
      focusedBorder: _border(AppColors.primary),
    );
  }

  static OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
      borderSide: BorderSide(color: color),
    );
  }
}
