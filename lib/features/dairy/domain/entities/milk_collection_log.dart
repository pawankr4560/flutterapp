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

  factory MilkCollectionLog.fromJson(Map<String, dynamic> json) {
    return MilkCollectionLog(
      id: _asString(json['id']),
      farmerName: _asString(
        json['farmerName'],
        fallback: _asString(json['farmer']),
      ),
      shift: _asString(json['shift'], fallback: _asString(json['milkType'])),
      quantityInLiters: _asDouble(
        json['quantityInLiters'] ?? json['quantity'],
      ),
      fatPercentage: _asDouble(
        json['fatPercentage'] ?? json['fat'],
      ),
      ratePerLiter: _asDouble(json['ratePerLiter'] ?? json['rate']),
      date: _asDate(json['date'] ?? json['collectionDate']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerName': farmerName,
      'shift': shift,
      'quantityInLiters': quantityInLiters,
      'fatPercentage': fatPercentage,
      'ratePerLiter': ratePerLiter,
      'date': _apiDate(date),
    };
  }

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

String _asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return fallback;
}

double _asDouble(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

DateTime? _asDate(Object? value) {
  final string = _asString(value);
  return string.isEmpty ? null : DateTime.tryParse(string);
}

String _apiDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
