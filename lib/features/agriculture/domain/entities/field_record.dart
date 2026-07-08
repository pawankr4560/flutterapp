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

  factory FieldRecord.fromJson(Map<String, dynamic> json) {
    return FieldRecord(
      id: _asString(json['id']),
      name: _asString(json['name']),
      crop: _asString(json['crop']),
      areaAcres: _asDouble(json['areaAcres']) ?? 0,
      status: _asString(json['status'], fallback: 'Healthy'),
      lastSprayedDate:
          _asDate(json['lastSprayedDate']) ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

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

String _asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return fallback;
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

DateTime? _asDate(Object? value) {
  final string = _asString(value);
  return string.isEmpty ? null : DateTime.tryParse(string);
}
