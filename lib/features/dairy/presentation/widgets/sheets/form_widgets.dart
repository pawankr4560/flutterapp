part of '../../pages/milk_directory_page.dart';

class _FormShell extends StatelessWidget {
  const _FormShell({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.88,
        minChildSize: 0.5,
        maxChildSize: 0.96,
        builder: (context, controller) {
          return ListView(
            controller: controller,
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(title, style: AppTextStyles.titleLarge(context)),
              const SizedBox(height: AppSpacing.md),
              child,
            ],
          );
        },
      ),
    );
  }
}

