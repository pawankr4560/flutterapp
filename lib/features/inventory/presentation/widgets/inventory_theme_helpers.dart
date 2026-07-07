part of '../pages/inventory_directory_page.dart';

const Color _amber = Color(0xFFF59E0B);
const Color _amberDark = Color(0xFFD97706);
const Color _blueGray = Color(0xFF475569);

ThemeData _constructionTheme(BuildContext context) {
  final base = Theme.of(context);
  final isDark = base.brightness == Brightness.dark;
  final baseScheme = base.colorScheme;
  final colorScheme = base.colorScheme.copyWith(
    primary: _amber,
    onPrimary: AppColors.surface,
    primaryContainer: _amber,
    onPrimaryContainer: AppColors.surface,
    secondary: _blueGray,
    surface: isDark ? baseScheme.surface : AppColors.surface,
    onSurface: isDark ? baseScheme.onSurface : AppColors.textPrimary,
    onSurfaceVariant: isDark
        ? baseScheme.onSurfaceVariant
        : AppColors.textSecondary,
    surfaceContainerHighest:
        isDark ? baseScheme.surfaceContainerHighest : AppColors.surfaceMuted,
    outline: isDark ? baseScheme.outline : AppColors.border,
  );
  final textTheme = AppTextStyles.theme(colorScheme);

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor:
        isDark ? base.scaffoldBackgroundColor : AppColors.background,
    textTheme: textTheme,
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor:
          isDark ? base.scaffoldBackgroundColor : AppColors.background,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: textTheme.titleMedium,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _amber,
        foregroundColor: AppColors.surface,
        minimumSize: const Size(64, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _amberDark,
        side: BorderSide(color: colorScheme.outline),
        minimumSize: const Size(64, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        textStyle: textTheme.labelLarge,
      ),
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      fillColor: colorScheme.surface,
      prefixIconColor: _amberDark,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: const BorderSide(color: _amber, width: 1.4),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: _amber,
      elevation: 6,
      shadowColor: AppColors.overlay,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return textTheme.bodyMedium!.copyWith(
          color: states.contains(WidgetState.selected)
              ? colorScheme.onSurface
              : colorScheme.onSurfaceVariant,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.surface
              : colorScheme.onSurfaceVariant,
        );
      }),
    ),
    progressIndicatorTheme: base.progressIndicatorTheme.copyWith(
      color: _amber,
      linearTrackColor: colorScheme.surfaceContainerHighest,
    ),
  );
}

IconData _categoryIcon(String category) {
  return switch (category) {
    'Cement' => Icons.foundation_rounded,
    'Steel' => Icons.construction_rounded,
    'Sand' => Icons.landscape_rounded,
    'Gitti / Aggregate' => Icons.grain_rounded,
    'Concrete' => Icons.factory_rounded,
    _ => Icons.warehouse_rounded,
  };
}

String? _requiredValidator(String? value) {
  return (value ?? '').trim().isEmpty ? 'Required' : null;
}

String? _positiveValidator(String? value) {
  final number = double.tryParse((value ?? '').trim()) ?? 0;
  return number <= 0 ? 'Enter a valid quantity' : null;
}

String? _phoneValidator(String? value) {
  final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
  return digits.length < 10 ? 'Enter a valid phone number' : null;
}

String _money(double value) {
  final amount = value.round().toString();
  if (amount.length <= 3) return 'Rs. $amount';
  final lastThree = amount.substring(amount.length - 3);
  var leading = amount.substring(0, amount.length - 3);
  final groups = <String>[];
  while (leading.length > 2) {
    groups.insert(0, leading.substring(leading.length - 2));
    leading = leading.substring(0, leading.length - 2);
  }
  if (leading.isNotEmpty) groups.insert(0, leading);
  return 'Rs. ${groups.join(',')},$lastThree';
}

String _date(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
