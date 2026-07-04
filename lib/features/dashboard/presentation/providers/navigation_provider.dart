import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the active dashboard tab index.
final dashboardTabProvider =
    NotifierProvider<DashboardTabNotifier, int>(DashboardTabNotifier.new);

/// Controls the active dashboard tab index.
class DashboardTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void selectTab(int index) {
    state = index;
  }
}
