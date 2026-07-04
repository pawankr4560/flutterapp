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

  int get bookingDays => endDate.difference(startDate).inDays + 1;

  double get totalAmount => bookingDays * dailyRate;

  bool get isActive {
    final normalized = status.toLowerCase();
    return normalized == 'booked' ||
        normalized == 'ongoing' ||
        normalized == 'upcoming';
  }
}
