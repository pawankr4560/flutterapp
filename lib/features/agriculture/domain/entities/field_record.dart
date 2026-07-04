/// Immutable field record for agriculture and pestiside tracking.
class FieldRecord {
  const FieldRecord({
    required this.id,
    required this.name,
    required this.crop,
    required this.areaAcres,
    required this.status,
    required this.lastSprayedDate,
  });

  final String id;
  final String name;
  final String crop;
  final double areaAcres;
  final String status;
  final DateTime lastSprayedDate;

  bool get needsAttention => status.toLowerCase() == 'needs attention';

  FieldRecord copyWith({
    String? id,
    String? name,
    String? crop,
    double? areaAcres,
    String? status,
    DateTime? lastSprayedDate,
  }) {
    return FieldRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      crop: crop ?? this.crop,
      areaAcres: areaAcres ?? this.areaAcres,
      status: status ?? this.status,
      lastSprayedDate: lastSprayedDate ?? this.lastSprayedDate,
    );
  }
}
