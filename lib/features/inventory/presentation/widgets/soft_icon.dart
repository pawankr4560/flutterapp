part of '../pages/inventory_directory_page.dart';

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: _amber.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Icon(icon, color: _amberDark, size: 22),
    );
  }
}

