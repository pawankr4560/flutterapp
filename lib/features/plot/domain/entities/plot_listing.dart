/// Immutable plot listing used by the Plot Management module.
class PlotListing {
  const PlotListing({
    required this.id,
    required this.plotNumber,
    required this.projectName,
    required this.location,
    required this.areaSqFt,
    required this.price,
    required this.status,
    required this.facing,
  });

  final String id;
  final String plotNumber;
  final String projectName;
  final String location;
  final double areaSqFt;
  final double price;
  final String status;
  final String facing;

  bool get isAvailable => status.toLowerCase() == 'available';
}
