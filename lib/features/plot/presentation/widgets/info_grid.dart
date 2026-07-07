part of '../pages/plot_directory_page.dart';

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.plot});

  final _PlotData plot;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.square_foot_rounded, 'Area', plot.area),
      (Icons.home_work_outlined, 'Property Type', plot.propertyType),
      (Icons.add_road_rounded, 'Road Width', plot.roadWidth),
      (Icons.electric_bolt_rounded, 'Electricity', plot.electricity),
      (Icons.water_drop_outlined, 'Water', plot.water),
      (Icons.verified_user_outlined, 'Registration', plot.registration),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 640 ? 3 : 2;
        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.45,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return AmenityTile(
              icon: item.$1,
              title: item.$2,
              subtitle: item.$3,
            );
          },
        );
      },
    );
  }
}

