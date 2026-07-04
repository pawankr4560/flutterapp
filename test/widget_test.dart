import 'package:finhub/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget smoke tests for the FinHub application shell.
void main() {
  testWidgets('FinHub shell navigates through placeholder routes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FinHubApp());
    await tester.pumpAndSettle();

    expect(find.text('FinHub'), findsOneWidget);
    expect(find.text('One App. Multiple Businesses.'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Business modules'), findsOneWidget);
    expect(find.text('Loan Management'), findsOneWidget);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Bookings'), findsOneWidget);
    expect(find.text('Reports'), findsOneWidget);
  });
}


