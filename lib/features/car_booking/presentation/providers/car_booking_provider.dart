import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  CarBookingState build() {
    return CarBookingState(
      vehicles: const [
        Vehicle(
          id: 'vehicle-swift-dzire',
          model: 'Swift Dzire',
          registrationNumber: 'DL 4C 1123',
          dailyRate: 1800,
          status: 'Available',
        ),
        Vehicle(
          id: 'vehicle-innova-crysta',
          model: 'Innova Crysta',
          registrationNumber: 'PB 10 AB 7788',
          dailyRate: 2400,
          status: 'Booked',
        ),
        Vehicle(
          id: 'vehicle-alto-k10',
          model: 'Alto K10',
          registrationNumber: 'PB 65 CJ 3345',
          dailyRate: 1200,
          status: 'Available',
        ),
        Vehicle(
          id: 'vehicle-bolero',
          model: 'Bolero Neo',
          registrationNumber: 'HR 26 BK 9081',
          dailyRate: 2200,
          status: 'Maintenance',
        ),
      ],
      bookings: [
        CarBooking(
          id: 'booking-innova-amit',
          customerName: 'Amit Verma',
          carModel: 'Innova Crysta',
          registrationNumber: 'PB 10 AB 7788',
          startDate: DateTime(2026, 7, 1),
          endDate: DateTime(2026, 7, 5),
          dailyRate: 2400,
          status: 'Ongoing',
        ),
        CarBooking(
          id: 'booking-swift-neha',
          customerName: 'Neha Gupta',
          carModel: 'Swift Dzire',
          registrationNumber: 'DL 4C 1123',
          startDate: DateTime(2026, 7, 3),
          endDate: DateTime(2026, 7, 4),
          dailyRate: 1800,
          status: 'Upcoming',
        ),
        CarBooking(
          id: 'booking-alto-karan',
          customerName: 'Karan Malhotra',
          carModel: 'Alto K10',
          registrationNumber: 'PB 65 CJ 3345',
          startDate: DateTime(2026, 6, 28),
          endDate: DateTime(2026, 6, 30),
          dailyRate: 1200,
          status: 'Completed',
        ),
      ],
    );
  }

  void addBooking(CarBooking booking) {
    state = CarBookingState(
      vehicles: [
        for (final vehicle in state.vehicles)
          vehicle.registrationNumber == booking.registrationNumber
              ? vehicle.copyWith(status: 'Booked')
              : vehicle,
      ],
      bookings: [booking, ...state.bookings],
    );
  }
}
