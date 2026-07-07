part of '../pages/plot_directory_page.dart';

class _AmenitiesGrid extends StatelessWidget {
  const _AmenitiesGrid({required this.amenities});

  final List<String> amenities;

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.security_rounded,
      Icons.add_road_rounded,
      Icons.water_drop_outlined,
      Icons.electric_bolt_rounded,
      Icons.park_outlined,
      Icons.school_outlined,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 640 ? 4 : 2;
        return GridView.builder(
          itemCount: amenities.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.18,
          ),
          itemBuilder: (context, index) {
            return AmenityTile(
              icon: icons[index % icons.length],
              title: amenities[index],
              subtitle: 'Included with plot',
            );
          },
        );
      },
    );
  }
}

