part of '../pages/milk_directory_page.dart';

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: _teal.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Icon(icon, color: _teal, size: 22),
    );
  }
}

