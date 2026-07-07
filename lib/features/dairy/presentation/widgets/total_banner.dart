part of '../pages/milk_directory_page.dart';

class _TotalBanner extends StatelessWidget {
  const _TotalBanner({required this.label, required this.amount});

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.titleMedium(context)),
          ),
          Text(
            _money(amount),
            style: AppTextStyles.titleLarge(context).copyWith(color: _teal),
          ),
        ],
      ),
    );
  }
}

