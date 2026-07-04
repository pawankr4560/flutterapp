/// Immutable dashboard activity item from any FinHub business module.
class RecentActivity {
  const RecentActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.iconName,
    required this.hexColor,
  });

  final String id;
  final String title;
  final String subtitle;
  final String timeAgo;
  final String iconName;
  final String hexColor;
}
