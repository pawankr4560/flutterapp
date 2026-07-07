part of '../pages/inventory_directory_page.dart';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.titleLarge(context));
  }
}

