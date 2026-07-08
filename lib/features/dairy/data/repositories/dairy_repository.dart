import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/constants/app_config.dart';
import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/data/api/api_exception.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';

import '../../domain/entities/milk_collection_log.dart';

final dairyRepositoryProvider = Provider<DairyRepository>((ref) {
  return HttpDairyRepository();
});

abstract class DairyRepository {
  Future<List<MilkCollectionLog>> listLogs();

  Future<void> addLog(MilkCollectionLog log);
}

class HttpDairyRepository implements DairyRepository {
  HttpDairyRepository({
    ApiClient? apiClient,
    String Function()? bearerTokenProvider,
  })  : _apiClient = apiClient ?? ApiClient(),
        _bearerTokenProvider =
            bearerTokenProvider ?? (() => AuthSession.instance.bearerToken);

  final ApiClient _apiClient;
  final String Function() _bearerTokenProvider;

  Uri get _collectionsUri =>
      Uri.parse('${AppConfig.baseUrl}/dairy/collections');

  @override
  Future<List<MilkCollectionLog>> listLogs() async {
    final response = await _apiClient.get(
      _collectionsUri,
      bearerToken: _bearerTokenProvider(),
    );
    return _logsFromResponse(response.body);
  }

  @override
  Future<void> addLog(MilkCollectionLog log) async {
    await _apiClient.post(
      _collectionsUri,
      bearerToken: _bearerTokenProvider(),
      body: {
        'farmerName': log.farmerName,
        'milkType': log.shift,
        'quantity': log.quantityInLiters,
        'fat': log.fatPercentage,
        'rate': log.ratePerLiter,
        'collectionDate': _apiDate(log.date),
      },
    );
  }

  List<MilkCollectionLog> _logsFromResponse(String body) {
    try {
      final decoded = body.trim().isEmpty ? null : jsonDecode(body);
      final items = switch (decoded) {
        {'data': {'items': final List<dynamic> values}} => values,
        {'items': final List<dynamic> values} => values,
        {'data': final List<dynamic> values} => values,
        List<dynamic> values => values,
        _ => const <dynamic>[],
      };
      return items
          .whereType<Map<String, dynamic>>()
          .map(MilkCollectionLog.fromJson)
          .where((log) => log.id.isNotEmpty)
          .toList();
    } catch (_) {
      throw const ApiException('Unable to parse dairy collections response.');
    }
  }

  String _apiDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

class InMemoryDairyRepository implements DairyRepository {
  InMemoryDairyRepository() {
    final now = DateTime.now();
    _logs = [
      MilkCollectionLog(
        id: 'milk-log-ram-morning',
        farmerName: 'Ram Singh',
        shift: 'Morning',
        quantityInLiters: 12.5,
        fatPercentage: 4.5,
        ratePerLiter: 50,
        date: now,
      ),
      MilkCollectionLog(
        id: 'milk-log-shyam-morning',
        farmerName: 'Shyam Lal',
        shift: 'Morning',
        quantityInLiters: 8,
        fatPercentage: 5.2,
        ratePerLiter: 55,
        date: now,
      ),
      MilkCollectionLog(
        id: 'milk-log-ram-evening',
        farmerName: 'Ram Singh',
        shift: 'Evening',
        quantityInLiters: 10,
        fatPercentage: 4.2,
        ratePerLiter: 48,
        date: now,
      ),
    ];
  }

  late List<MilkCollectionLog> _logs;

  @override
  Future<List<MilkCollectionLog>> listLogs() async => List.unmodifiable(_logs);

  @override
  Future<void> addLog(MilkCollectionLog log) async {
    _logs = [..._logs, log];
  }
}
