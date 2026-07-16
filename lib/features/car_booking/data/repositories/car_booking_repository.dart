import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/constants/app_config.dart';
import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/data/api/api_exception.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';

import '../../domain/entities/car_booking.dart';
import '../../domain/entities/vehicle.dart';

final carBookingRepositoryProvider = Provider<CarBookingRepository>((ref) {
  return HttpCarBookingRepository();
});

abstract class CarBookingRepository {
  Future<List<Vehicle>> listVehicles();

  Future<List<CarBooking>> listBookings();

  Future<CarBooking> createBooking({
    required String vehicleId,
    required String customerName,
    required DateTime startDate,
    required DateTime endDate,
  });
}

class HttpCarBookingRepository implements CarBookingRepository {
  HttpCarBookingRepository({
    ApiClient? apiClient,
    String Function()? bearerTokenProvider,
  })  : _apiClient = apiClient ?? ApiClient(),
        _bearerTokenProvider =
            bearerTokenProvider ?? (() => AuthSession.instance.bearerToken);

  final ApiClient _apiClient;
  final String Function() _bearerTokenProvider;

  Uri get _vehiclesUri =>
      Uri.parse('${AppConfig.baseUrl}/car-booking/vehicles');
  Uri get _bookingsUri =>
      Uri.parse('${AppConfig.baseUrl}/car-booking/bookings');

  @override
  Future<List<Vehicle>> listVehicles() async {
    final response = await _apiClient.get(
      _vehiclesUri,
      bearerToken: _bearerTokenProvider(),
    );
    return _listFromResponse(response.body)
        .whereType<Map<String, dynamic>>()
        .map(Vehicle.fromJson)
        .where((vehicle) => vehicle.id.isNotEmpty)
        .toList();
  }

  @override
  Future<List<CarBooking>> listBookings() async {
    final response = await _apiClient.get(
      _bookingsUri,
      bearerToken: _bearerTokenProvider(),
    );
    return _listFromResponse(response.body)
        .whereType<Map<String, dynamic>>()
        .map(CarBooking.fromJson)
        .where((booking) => booking.id.isNotEmpty)
        .toList();
  }

  @override
  Future<CarBooking> createBooking({
    required String vehicleId,
    required String customerName,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _apiClient.post(
      _bookingsUri,
      bearerToken: _bearerTokenProvider(),
      body: {
        'vehicleId': vehicleId,
        'customerName': customerName,
        'startDate': _dateOnly(startDate),
        'endDate': _dateOnly(endDate),
      },
    );
    final data = _mapFromResponse(response.body);
    final booking = CarBooking.fromJson(data);
    if (booking.id.isEmpty) {
      throw const ApiException('Unable to parse created booking response.');
    }
    return booking;
  }

  List<dynamic> _listFromResponse(String body) {
    try {
      final decoded = body.trim().isEmpty ? null : jsonDecode(body);
      return switch (decoded) {
        {'data': {'items': final List<dynamic> values}} => values,
        {'data': final List<dynamic> values} => values,
        {'items': final List<dynamic> values} => values,
        List<dynamic> values => values,
        _ => const <dynamic>[],
      };
    } catch (_) {
      throw const ApiException('Unable to parse car booking response.');
    }
  }

  Map<String, dynamic> _mapFromResponse(String body) {
    try {
      final decoded = body.trim().isEmpty ? null : jsonDecode(body);
      return switch (decoded) {
        {'data': final Map<String, dynamic> data} => data,
        Map<String, dynamic> data => data,
        _ => throw const ApiException('Unable to parse booking response.'),
      };
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Unable to parse booking response.');
    }
  }
}

String _dateOnly(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

class InMemoryCarBookingRepository implements CarBookingRepository {
  List<Vehicle> _vehicles = const [
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
  ];

  List<CarBooking> _bookings = [
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
  ];

  @override
  Future<List<Vehicle>> listVehicles() async => List.unmodifiable(_vehicles);

  @override
  Future<List<CarBooking>> listBookings() async => List.unmodifiable(_bookings);

  @override
  Future<CarBooking> createBooking({
    required String vehicleId,
    required String customerName,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final vehicle = _vehicles.firstWhere((item) => item.id == vehicleId);
    final booking = CarBooking(
      id: 'booking-${DateTime.now().microsecondsSinceEpoch}',
      customerName: customerName,
      carModel: vehicle.model,
      registrationNumber: vehicle.registrationNumber,
      startDate: startDate,
      endDate: endDate,
      dailyRate: vehicle.dailyRate,
      status: 'Upcoming',
    );
    _vehicles = [
      for (final vehicle in _vehicles)
        vehicle.registrationNumber == booking.registrationNumber
            ? vehicle.copyWith(status: 'Booked')
            : vehicle,
    ];
    _bookings = [booking, ..._bookings];
    return booking;
  }
}
