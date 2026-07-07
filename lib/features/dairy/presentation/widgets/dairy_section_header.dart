part of '../pages/milk_directory_page.dart';

class _DairySectionHeader extends StatelessWidget {
  const _DairySectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.titleLarge(context));
  }
}

