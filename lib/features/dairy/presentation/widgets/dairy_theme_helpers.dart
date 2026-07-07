part of '../pages/milk_directory_page.dart';

ThemeData _dairyTheme(BuildContext context) {
  final base = Theme.of(context);
  final isDark = base.brightness == Brightness.dark;
  final baseScheme = base.colorScheme;
  final colorScheme = base.colorScheme.copyWith(
    primary: AppColors.primary,
    onPrimary: AppColors.surface,
    primaryContainer: AppColors.primary,
    onPrimaryContainer: AppColors.surface,
    secondary: AppColors.accentDark,
    surface: isDark ? baseScheme.surface : AppColors.surface,
    onSurface: isDark ? baseScheme.onSurface : AppColors.textPrimary,
    onSurfaceVariant: isDark
        ? baseScheme.onSurfaceVariant
        : AppColors.textSecondary,
    surfaceContainerHighest: isDark
        ? baseScheme.surfaceContainerHighest
        : AppColors.surfaceMuted,
    outline: isDark ? baseScheme.outline : AppColors.border,
  );
  final textTheme = AppTextStyles.theme(colorScheme);

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: isDark
        ? base.scaffoldBackgroundColor
        : AppColors.background,
    textTheme: textTheme,
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: isDark
          ? base.scaffoldBackgroundColor
          : AppColors.background,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: textTheme.titleMedium,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.surface,
      extendedTextStyle: AppTextStyles.labelLarge(
        context,
      ).copyWith(color: AppColors.surface),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        disabledBackgroundColor: colorScheme.outline,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        textStyle: textTheme.labelLarge,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: colorScheme.onSurface),
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      fillColor: colorScheme.surface,
      prefixIconColor: AppColors.primary,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.primary
              : colorScheme.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.surface
              : colorScheme.onSurface;
        }),
        iconColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.surface
              : colorScheme.onSurfaceVariant;
        }),
        side: WidgetStateProperty.all(BorderSide(color: colorScheme.outline)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: AppColors.primary,
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
      color: AppColors.primary,
      linearTrackColor: colorScheme.surfaceContainerHighest,
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: AppColors.transparent,
      modalBackgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
    ),
  );
}

double _number(String value) => double.tryParse(value.trim()) ?? 0;

String _money(double value) => 'Rs. ${value.toStringAsFixed(0)}';

String _trim(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}

String _formatShortDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

IconData _productIcon(String product) {
  return switch (product.toLowerCase()) {
    'paneer' => Icons.inventory_2_rounded,
    'ghee' => Icons.opacity_rounded,
    'curd' => Icons.icecream_rounded,
    'butter' => Icons.breakfast_dining_rounded,
    _ => Icons.local_drink_rounded,
  };
}
