import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'data/api/api_client.dart';
import 'features/auth/application/services/auth_session.dart';

/// FinHub application entrypoint.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthSession.instance.initialize();
  ApiClient.onUnauthorized = () {
    AuthSession.instance.logout();
  };
  runApp(const ProviderScope(child: FinHubApp()));
}


