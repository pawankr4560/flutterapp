/// Immutable business module metadata displayed on the dashboard.
class BusinessModule {
  const BusinessModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.hexColor,
    required this.isEnabled,
    required this.routePath,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconName;
  final String hexColor;
  final bool isEnabled;
  final String routePath;
}
