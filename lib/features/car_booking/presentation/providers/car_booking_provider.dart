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
    AsyncNotifierProvider<CarBookingNotifier, CarBookingState>(
  CarBookingNotifier.new,
);

/// Manages the in-memory car booking ledger.
class CarBookingNotifier extends AsyncNotifier<CarBookingState> {
  late final CarBookingRepository _repository;

  @override
  Future<CarBookingState> build() {
    _repository = ref.read(carBookingRepositoryProvider);
    return _currentState();
  }

  Future<CarBookingState> _currentState() async {
    return CarBookingState(
      vehicles: await _repository.listVehicles(),
      bookings: await _repository.listBookings(),
    );
  }

  Future<void> createBooking({
    required String vehicleId,
    required String customerName,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await _repository.createBooking(
      vehicleId: vehicleId,
      customerName: customerName,
      startDate: startDate,
      endDate: endDate,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(_currentState);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_currentState);
  }
}
