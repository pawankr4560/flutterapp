import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/car_booking_repository.dart';
import '../../domain/entities/car_booking.dart';
import '../../domain/entities/vehicle.dart';

/// Car booking module state containing fleet and booking records.
class CarBookingState {
  const CarBookingState({
    required this.vehicles,
    required this.bookings,
  });

  final List<Vehicle> vehicles;
  final List<CarBooking> bookings;
}

/// Provides car rental fleet and bookings for the Car Booking module.
final carBookingProvider =
    NotifierProvider<CarBookingNotifier, CarBookingState>(
  CarBookingNotifier.new,
);

/// Manages the in-memory car booking ledger.
class CarBookingNotifier extends Notifier<CarBookingState> {
  late final CarBookingRepository _repository;

  @override
  CarBookingState build() {
    _repository = ref.read(carBookingRepositoryProvider);
    return _currentState();
  }

  CarBookingState _currentState() {
    return CarBookingState(
      vehicles: _repository.listVehicles(),
      bookings: _repository.listBookings(),
    );
  }

  void addBooking(CarBooking booking) {
    _repository.addBooking(booking);
    state = _currentState();
  }
}
