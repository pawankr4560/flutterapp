/// Immutable car rental booking used by the Car Booking module.
class CarBooking {
  const CarBooking({
    required this.id,
    required this.customerName,
    required this.carModel,
    required this.registrationNumber,
    required this.startDate,
    required this.endDate,
    required this.dailyRate,
    required this.status,
  });

  final String id;
  final String customerName;
  final String carModel;
  final String registrationNumber;
  final DateTime startDate;
  final DateTime endDate;
  final double dailyRate;
  final String status;

  factory CarBooking.fromJson(Map<String, dynamic> json) {
    return CarBooking(
      id: json['id']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      carModel: json['carModel']?.toString() ?? '',
      registrationNumber: json['registrationNumber']?.toString() ?? '',
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      endDate: DateTime.tryParse(json['endDate']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      dailyRate: _asDouble(json['dailyRate']),
      status: json['status']?.toString() ?? '',
    );
  }

  int get bookingDays => endDate.difference(startDate).inDays + 1;

  double get totalAmount => bookingDays * dailyRate;

  bool get isActive {
    final normalized = status.toLowerCase();
    return normalized == 'booked' ||
        normalized == 'ongoing' ||
        normalized == 'upcoming';
  }
}

double _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
