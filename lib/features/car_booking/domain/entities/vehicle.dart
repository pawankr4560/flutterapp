/// Immutable vehicle item for the car rental fleet.
class Vehicle {
  const Vehicle({
    required this.id,
    required this.model,
    required this.registrationNumber,
    required this.dailyRate,
    required this.status,
  });

  final String id;
  final String model;
  final String registrationNumber;
  final double dailyRate;
  final String status;

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      registrationNumber: json['registrationNumber']?.toString() ?? '',
      dailyRate: _asDouble(json['dailyRate']),
      status: json['status']?.toString() ?? '',
    );
  }

  bool get isAvailable => status.toLowerCase() == 'available';

  Vehicle copyWith({
    String? id,
    String? model,
    String? registrationNumber,
    double? dailyRate,
    String? status,
  }) {
    return Vehicle(
      id: id ?? this.id,
      model: model ?? this.model,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      dailyRate: dailyRate ?? this.dailyRate,
      status: status ?? this.status,
    );
  }
}

double _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
