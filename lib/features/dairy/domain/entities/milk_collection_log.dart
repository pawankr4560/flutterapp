/// Immutable daily milk collection entry for a dairy farmer.
class MilkCollectionLog {
  const MilkCollectionLog({
    required this.id,
    required this.farmerName,
    required this.shift,
    required this.quantityInLiters,
    required this.fatPercentage,
    required this.ratePerLiter,
    required this.date,
  });

  final String id;
  final String farmerName;
  final String shift;
  final double quantityInLiters;
  final double fatPercentage;
  final double ratePerLiter;
  final DateTime date;

  double get totalAmount => quantityInLiters * ratePerLiter;

  MilkCollectionLog copyWith({
    String? id,
    String? farmerName,
    String? shift,
    double? quantityInLiters,
    double? fatPercentage,
    double? ratePerLiter,
    DateTime? date,
  }) {
    return MilkCollectionLog(
      id: id ?? this.id,
      farmerName: farmerName ?? this.farmerName,
      shift: shift ?? this.shift,
      quantityInLiters: quantityInLiters ?? this.quantityInLiters,
      fatPercentage: fatPercentage ?? this.fatPercentage,
      ratePerLiter: ratePerLiter ?? this.ratePerLiter,
      date: date ?? this.date,
    );
  }
}
