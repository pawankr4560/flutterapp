import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _storageKey = 'theme_mode';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  ThemeMode build() {
    unawaited(_loadSavedThemeMode());
    return ThemeMode.light;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      await _storage.write(key: _storageKey, value: mode.name);
    } catch (error, stackTrace) {
      if (!kIsWeb) {
        Error.throwWithStackTrace(error, stackTrace);
      }
      if (kDebugMode) {
        debugPrint('Unable to persist the web theme: $error');
      }
    }
  }

  Future<void> _loadSavedThemeMode() async {
    String? value;
    try {
      value = await _storage.read(key: _storageKey);
    } catch (error, stackTrace) {
      if (!kIsWeb) {
        Error.throwWithStackTrace(error, stackTrace);
      }
      if (kDebugMode) {
        debugPrint('Unable to read the saved web theme: $error');
      }
    }
    final mode = switch (value) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };

    if (state != mode) {
      state = mode;
    }
  }
}
