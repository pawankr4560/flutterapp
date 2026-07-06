import 'package:finhub/app/theme.dart';
import 'package:finhub/app/theme_controller.dart';
import 'package:finhub/features/dashboard/domain/entities/recent_activity.dart';
import 'package:finhub/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_activity_tile.dart';
import 'package:finhub/features/dairy/presentation/pages/milk_directory_page.dart';
import 'package:finhub/features/inventory/presentation/pages/inventory_directory_page.dart';
import 'package:finhub/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  testWidgets('dashboard header cycles theme mode on tap', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        Column(
          children: [
            const DashboardHeader(),
            Consumer(
              builder: (context, ref, _) {
                return Text(
                  ref.watch(themeModeProvider).name,
                  key: const ValueKey('theme-mode-value'),
                );
              },
            ),
          ],
        ),
      ),
    );

    expect(find.text('light'), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.light_mode_outlined));
    await tester.pumpAndSettle();

    expect(find.text('system'), findsOneWidget);
    expect(find.byIcon(Icons.phone_android_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.phone_android_rounded));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('theme-mode-value')), findsOneWidget);
    expect(find.text('dark'), findsOneWidget);
  });

  testWidgets('dashboard recent activity card text stays readable in dark mode', (
    tester,
  ) async {
    final colorScheme = FinHubTheme.dark.colorScheme;

    await tester.pumpWidget(
      _testApp(
        const RecentActivityTile(
          activity: RecentActivity(
            id: 'activity-1',
            title: 'Rahul Sharma - Rs. 50,000',
            subtitle: 'Loan repayment collected',
            timeAgo: '5 mins ago',
            iconName: 'check_circle',
            hexColor: '#4F46E5',
          ),
        ),
      ),
    );

    expect(
      _textColor(tester, 'Rahul Sharma - Rs. 50,000'),
      colorScheme.onSurface,
    );
    expect(
      _textColor(tester, 'Loan repayment collected'),
      colorScheme.onSurfaceVariant,
    );
  });

  testWidgets('construction materials screen keeps readable text in dark mode', (
    tester,
  ) async {
    final colorScheme = FinHubTheme.dark.colorScheme;

    await tester.pumpWidget(_testApp(const InventoryDirectoryPage()));

    expect(_textColor(tester, 'Construction Materials'), colorScheme.onSurface);
    expect(
      _textColor(tester, 'Quality Materials, Delivered'),
      colorScheme.onSurfaceVariant,
    );
    expect(_textColor(tester, 'Total Products'), colorScheme.onSurfaceVariant);
  });

  testWidgets('dairy screen keeps readable text in dark mode', (tester) async {
    final colorScheme = FinHubTheme.dark.colorScheme;

    await tester.pumpWidget(_testApp(const MilkDirectoryPage()));

    expect(_textColor(tester, 'Dairy Products'), colorScheme.onSurface);
    expect(
      _textColor(tester, 'Manage your dairy business'),
      colorScheme.onSurfaceVariant,
    );
    expect(_textColor(tester, 'Today Collection'), colorScheme.onSurfaceVariant);
  });

  testWidgets('profile screen keeps readable text in dark mode', (tester) async {
    final colorScheme = FinHubTheme.dark.colorScheme;

    await tester.pumpWidget(_testApp(const ProfileScreen()));

    expect(_textColor(tester, 'Profile'), colorScheme.onSurface);
    expect(_textColor(tester, 'Personal details'), colorScheme.onSurface);
    expect(_textColor(tester, 'Email not available'), colorScheme.onSurfaceVariant);
  });
}

Widget _testApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: FinHubTheme.light,
      darkTheme: FinHubTheme.dark,
      themeMode: ThemeMode.dark,
      home: Scaffold(body: child),
    ),
  );
}

Color? _textColor(WidgetTester tester, String text) {
  final widget = tester.widget<Text>(find.text(text).first);
  return widget.style?.color;
}
