part of '../pages/plot_directory_page.dart';

class _PlotCardFromData extends StatelessWidget {
  const _PlotCardFromData({
    required this.plot,
    required this.onViewDetails,
    this.isCompact = false,
  });

  final _PlotData plot;
  final VoidCallback onViewDetails;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return PlotCard(
      heroTag: plot.id,
      imageUrl: plot.images.first,
      title: plot.title,
      location: plot.location,
      area: plot.area,
      price: plot.price,
      status: plot.status,
      amenities: plot.amenities,
      isCompact: isCompact,
      onFavorite: () {},
      onViewDetails: onViewDetails,
    );
  }
}

